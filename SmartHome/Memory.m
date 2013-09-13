//
//  Memory.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Memory.h" 
#import "JsonUtils.h"
#import "SMShared.h"
#import "NSString+StringUtils.h"

#define DIRECTORY [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"smarthome-units"]

@implementation Memory

@synthesize units;
@synthesize currentUnit;
@synthesize subscriptions;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(self.units == nil) {
        self.units = [NSMutableArray array];
    }
}

#pragma mark -
#pragma mark subscriptions 

- (void)subscribeHandler:(Class)handler for:(id)obj {
    @synchronized(self.subscriptions) {
        if(obj == nil || handler == nil) return;
        
        NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:[handler description]];
        if(subscriptions_ == nil) {
            subscriptions_ = [NSMutableArray array];
            [subscriptions_ addObject:obj];
            [self.subscriptions setObject:subscriptions_ forKey:[handler description]];
            return;
        }
        BOOL found = NO;
        for(int i=0; i<subscriptions_.count; i++) {
            if(obj == [subscriptions_ objectAtIndex:i]) {
                found = YES;
                break;
            }
        }
        if(!found) {
            [subscriptions_ addObject:obj];
        }
    }
}

- (NSArray *)getSubscriptionsFor:(Class)handler {
    @synchronized(self.subscriptions) {
        if(handler == nil) return nil;
        return [self.subscriptions objectForKey:[handler description]];
    }
}

- (void)unSubscribeHandler:(Class)handler for:(id)obj {
    @synchronized(self.subscriptions) {
        if(obj == nil || handler == nil) return;
        NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:[handler description]];
        if(subscriptions_ != nil) {
            [subscriptions_ removeObject:obj];
        }
    }
}

#pragma mark -
#pragma mark units

- (NSArray *)updateUnits:(NSArray *)newUnits {
    @synchronized(self) {
        if(newUnits == nil || newUnits.count == 0) {
            [self.units removeAllObjects];
            return self.units;
        }
        
        if(self.units.count == 0) {
            [self.units addObjectsFromArray:newUnits];
            return self.units;
        }
        
        NSMutableDictionary *updateList = [NSMutableDictionary dictionary];
        NSMutableArray *createList = [NSMutableArray array];
        
        for(int i=0; i<newUnits.count; i++) {
            Unit *newUnit = [newUnits objectAtIndex:i];
            
            BOOL unitFound = NO;
            for(int j=0; j<self.units.count; j++) {
                Unit *oldUnit = [self.units objectAtIndex:j];
                if([oldUnit.identifier isEqualToString:newUnit.identifier]) {
                    unitFound = YES;
                    if(newUnit.updateTime.timeIntervalSince1970 > oldUnit.updateTime.timeIntervalSince1970) {
                        [updateList setObject:newUnit forKey:[NSNumber numberWithInteger:j].stringValue];
                        break;
                    }
                }
            }
            
            if(!unitFound) {
                [createList addObject:newUnit];
            }
        }
        
        if(updateList.count > 0) {
            NSEnumerator *keyEnumerator = updateList.keyEnumerator;
            for(NSString *key in keyEnumerator) {
                NSInteger replaceIndex = [key integerValue];
                [self.units setObject:[updateList objectForKey:key] atIndexedSubscript:replaceIndex];
            }
        }
        
        if(createList.count > 0) {
            for(int i=0; i<createList.count; i++) {
                [self.units addObject:[createList objectAtIndex:i]];
            }
        }
        
        return self.units;
    }
}

- (void)clearUnits {
    @synchronized(self) {
        [self.units removeAllObjects];
    }
}

- (void)updateUnitDevices:(NSArray *)devicesStatus forUnit:(NSString *)identifier {
    @synchronized(self) {
        if(devicesStatus == nil || devicesStatus.count == 0) return;
        Unit *unit = [self findUnitByIdentifierInternal:identifier];
        if(unit != nil && unit.devices != nil && unit.devices.count > 0) {
            for(DeviceStatus *ds in devicesStatus) {
                for(Device *device in unit.devices) {
                    if([ds.deviceIdentifer isEqualToString:device.identifier]) {
                        device.state = ds.state;
                        device.status = ds.status;
                        break;
                    }
                }
            }
        }
    }
}

- (Unit *)findUnitByIdentifier:(NSString *)identifier {
    @synchronized(self) {
        return [self findUnitByIdentifierInternal:identifier];
    }
}

- (Unit *)findUnitByIdentifierInternal:(NSString *)identifier {
    if([NSString isBlank:identifier]) return nil;
    if(self.units == nil || self.units.count == 0) return nil;
    for(Unit *u in self.units) {
        if([u.identifier isEqualToString:identifier]) {
            return u;
        }
    }
    return nil;
}

- (NSArray *)allUnitsIdentifierAsArray {
    @synchronized(self) {
        NSMutableArray *ids = [NSMutableArray array];
        if(self.units == nil || self.units.count == 0) return ids;
        for(Unit *unit in self.units) {
            [ids addObject:unit.identifier];
        }
        return ids;
    }
}

- (void)updateSceneList:(NSString *)unitIdentifier sceneList:(NSArray *)sceneList hashCode:(NSNumber *)hashCode {
    @synchronized(self) {
        if([NSString isBlank:unitIdentifier]) return;
        Unit *unit = [self findUnitByIdentifierInternal:unitIdentifier];
        if(unit != nil) {
            [unit.scenesModeList removeAllObjects];
            if(sceneList != nil) {
                [unit.scenesModeList addObjectsFromArray:sceneList];
            }
            unit.sceneHashCode = (hashCode == nil ? [NSNumber numberWithInteger:0] : hashCode);
        }
    }
}

- (Unit *)currentUnit {
    @synchronized(self) {
        if(self.units.count == 0) return nil;
        if(currentUnit == nil) {
            return [self.units objectAtIndex:0];
        }
        return currentUnit;
    }
}

- (void)changeCurrentUnitTo:(NSString *)unitIdentifier {
    @synchronized(self) {
        if([NSString isBlank:unitIdentifier]) return;
        if(self.units == nil) return;
        for(Unit *unit in self.units) {
            if([unitIdentifier isEqualToString:unit.identifier]) {
                currentUnit = unit;
                break;
            }
        }
    }
}

#pragma mark -
#pragma mark units file manager

- (void)syncUnitsToDisk {
    @synchronized(self) {
        @try {
            BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:DIRECTORY];
            if(!directoryExists) {
                NSError *error;
                BOOL createDirSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:DIRECTORY withIntermediateDirectories:YES attributes:nil error:&error];
                if(!createDirSuccess) {
                    NSLog(@"create directory for units failed , error >>> %@", error.description);
                    return;
                }
            }
            
            NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
            
            if(self.units == nil || self.units.count == 0) {
                BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
                if(exists) {
                    NSError *error;
                    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
                    if(error) {
                        NSLog(@"remove unit file failed. error >>>>  %@", error.description);
                    }
                }
                return;
            }
            
            NSMutableArray *unitsToSave = [NSMutableArray array];
            for(Unit *unit in self.units) {
                [unitsToSave addObject:[unit toJson]];
            }
            
            NSData *data = [JsonUtils createJsonDataFromDictionary:[NSDictionary dictionaryWithObject:unitsToSave forKey:@"units"]];
            
            BOOL success = [data writeToFile:filePath atomically:YES];
            
            if(!success) {
                NSLog(@"save units failed ...");
            }
        }
        @catch (NSException *exception) {
            NSLog(@"save units exception reason %@", exception.reason);
        }
        @finally {
            
        }
    }
}

- (void)loadUnitsFromDisk {
    @synchronized(self) {
        NSString *filePath = [DIRECTORY stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt", [SMShared current].settings.account]];
        if([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
            NSDictionary *json = [JsonUtils createDictionaryFromJson:data];
            NSArray *_units_ = [json objectForKey:@"units"];
            if(_units_ != nil) {
                NSMutableArray *newUnits = [NSMutableArray array];
                for(NSDictionary *_unit in _units_) {
                    [newUnits addObject:[[Unit alloc] initWithJson:_unit]];
                }
                [self.units removeAllObjects];
                [self.units addObjectsFromArray:newUnits];
                return;
            }
        }
        [self.units removeAllObjects];
    }
}

- (void)clear {
    @synchronized(self) {
        if(self.units != nil) [self.units removeAllObjects];
        if(self.subscriptions != nil) [self.subscriptions removeAllObjects];
    }
}


#pragma mark -
#pragma mark getter and setter's

- (NSMutableDictionary *)subscriptions {
    if(subscriptions == nil) {
        subscriptions = [NSMutableDictionary dictionary];
    }
    return subscriptions;
}

@end
