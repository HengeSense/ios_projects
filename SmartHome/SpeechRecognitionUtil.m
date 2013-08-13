//
//  SpeechRecognitionButton.m
//  SpeechRecognition
//
//  Created by young on 6/19/13.
//  Copyright (c) 2013 young. All rights reserved.
//

#import "SpeechRecognitionUtil.h"

@implementation SpeechRecognitionUtil {
    IFlySpeechRecognizer *speechRecognizer;
    NSMutableString *textResult;
}

@synthesize domain;
@synthesize vadBos;
@synthesize vadEos;
@synthesize sampleRate;
@synthesize asrPtt;
@synthesize asrSch;
@synthesize plainResult;
@synthesize grammarID;
@synthesize speechRecognitionNotificationDelegate;

#pragma mark -
#pragma mark initializations

//- (id)initWithFrame:(CGRect)frame andMode:(RECORD_MODE)_recodeMode_ {
//    self = [super initWithFrame:frame];
//    if(self) {
//        [self initDefaults];
//        
//        recordMode = _recodeMode_;
//        if(self.recordMode == RECORD_MODE_BUTTON_AUTO) {
//            [self addTarget:self action:@selector(touchUpInsideForAutoMode:) forControlEvents:UIControlEventTouchUpInside];
//        } else if(self.recordMode == RECORD_MODE_BUTTON_MANUAL) {
//            [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
//            [self addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
//            [self addTarget:self action:@selector(dragEnter:) forControlEvents:UIControlEventTouchDragEnter];
//            [self addTarget:self action:@selector(dragExit:) forControlEvents:UIControlEventTouchDragExit];
//            [self addTarget:self action:@selector(touchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
//        }
//    }
//    return self;
//}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(speechRecognizer == nil) {
        NSString *initString = [NSString stringWithFormat:@"appid=%@,timeout=%@", IFLY_APP_ID, CONNECTION_TIME_OUT];
        speechRecognizer = [IFlySpeechRecognizer createRecognizer:initString delegate:self];
    }
    self.domain = @"iat";
    self.vadBos = @"4000";
    self.vadEos = @"700";
    self.asrSch = @"0";
    self.asrPtt = @"1";
    self.sampleRate = @"16000";
    self.plainResult = @"0";
}

//#pragma mark -
//#pragma mark speech recognizer event for manual
//
//- (void)touchDown:(id)sender {
//    [self startListening];
//}
//
//- (void)touchUpInside:(id)sender {
//    [self stopListening];
//}
//
//- (void)dragEnter:(id)sender {
//}
//
//- (void)dragExit:(id)sender {
//}
//
//- (void)touchUpOutside:(id)sender {
//    [speechRecognizer cancel];
//    if(self.speechRecognitionNotificationDelegate == nil) return;
//    if([self.speechRecognitionNotificationDelegate respondsToSelector:@selector(recognizeCancelled)]) {
//        [self.speechRecognitionNotificationDelegate recognizeCancelled];
//    }
//}
//
//#pragma mark -
//#pragma mark speech recognizer event for auto
//
//- (void)touchUpInsideForAutoMode:(id)sender {
//    if(lockButton) return;
//    lockButton = YES;
//    if(isRecognizing) {
//        [self stopListening];
//    } else {
//        [self startListening];
//    }
//}

#pragma mark -
#pragma mark iFly recognizer control

- (void)startListening {
    textResult = nil;
    [speechRecognizer setParameter:@"domain" value:self.domain];
    [speechRecognizer setParameter:@"vad_bos" value:self.vadBos];
    [speechRecognizer setParameter:@"vad_eos" value:self.vadEos];
    [speechRecognizer setParameter:@"asr_sch" value:self.asrSch];
    [speechRecognizer setParameter:@"asr_ptt" value:self.asrPtt];
    [speechRecognizer setParameter:@"sample_rate" value:self.sampleRate];
    [speechRecognizer setParameter:@"plain_result" value:self.plainResult];
    if([@"asr" isEqualToString:self.domain]) {
        [speechRecognizer setParameter:@"grammarID" value:self.grammarID];
    }
    [speechRecognizer startListening];
}

- (void)stopListening {
    [speechRecognizer stopListening];
}

- (void)cancel {
    [speechRecognizer cancel];
}

#pragma mark -
#pragma mark iFly speech recognizer delegate

/* volume value is between 0 and 30 */
- (void)onVolumeChanged:(int)volume {
    if(self.speechRecognitionNotificationDelegate == nil) return;
    if([self.speechRecognitionNotificationDelegate respondsToSelector:@selector(speakerVolumeChanged:)]) {
        [self.speechRecognitionNotificationDelegate speakerVolumeChanged:volume];
    }
}

- (void)onBeginOfSpeech {
    if(self.speechRecognitionNotificationDelegate == nil) return;
    if([self.speechRecognitionNotificationDelegate respondsToSelector:@selector(beginRecord)]) {
        [self.speechRecognitionNotificationDelegate beginRecord];
    }
}

- (void)onEndOfSpeech {
    if(self.speechRecognitionNotificationDelegate == nil) return;
    if([self.speechRecognitionNotificationDelegate respondsToSelector:@selector(endRecord)]) {
        [self.speechRecognitionNotificationDelegate endRecord];
    }
}

- (void)onResults:(NSArray *)results {
    if(textResult == nil) {
        textResult = [[NSMutableString alloc] init];
        NSDictionary *dic = [results objectAtIndex:0];
        for(NSString *key in dic) {
            [textResult appendFormat:@"%@", key];
        }
    }
}

- (void)onCancel {
    // need to test
    if(self.speechRecognitionNotificationDelegate != nil
       && [self.speechRecognitionNotificationDelegate respondsToSelector:@selector(recognizeCancelled)]) {
        [self.speechRecognitionNotificationDelegate recognizeCancelled];
    }
}

- (void)onError:(IFlySpeechError *)errorCode {
    if(self.speechRecognitionNotificationDelegate == nil) return;
    if(errorCode.errorCode == 0) {
        if([self.speechRecognitionNotificationDelegate respondsToSelector:@selector(recognizeSuccess:)]) {
            [self.speechRecognitionNotificationDelegate recognizeSuccess:textResult];
        }
    } else {
        if([self.speechRecognitionNotificationDelegate respondsToSelector:@selector(recognizeError:)]) {
            [self.speechRecognitionNotificationDelegate recognizeError:errorCode.errorCode];
        }
    }
}

@end
