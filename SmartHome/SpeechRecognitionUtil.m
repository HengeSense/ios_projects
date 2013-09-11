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
    self.vadBos = @"3000";
    self.vadEos = @"1800";
    self.asrSch = @"0";
    self.asrPtt = @"0";
    self.sampleRate = @"16000";
    self.plainResult = @"0";
}


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
