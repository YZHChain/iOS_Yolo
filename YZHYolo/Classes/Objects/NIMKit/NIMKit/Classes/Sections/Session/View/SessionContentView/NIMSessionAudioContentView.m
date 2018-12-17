//
//  SessionAudioCententView.m
//  NIMDemo
//
//  Created by chris.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NIMSessionAudioContentView.h"
#import "UIView+NIM.h"
#import "NIMMessageModel.h"
#import "UIImage+NIMKit.h"
#import "NIMKitAudioCenter.h"
#import "NIMKit.h"

@interface NIMSessionAudioContentView()<NIMMediaManagerDelegate>

@property (nonatomic,strong) UIImageView *voiceImageView;

@property (nonatomic,strong) UILabel *durationLabel;

@end

@implementation NIMSessionAudioContentView

-(instancetype)initSessionMessageContentView{
    self = [super initSessionMessageContentView];
    if (self) {
        [self addVoiceView];
        [[NIMSDK sharedSDK].mediaManager addDelegate:self];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NIMSDK sharedSDK].mediaManager removeDelegate:self];
}

- (void)setPlaying:(BOOL)isPlaying
{
    if (isPlaying) {
        [self.voiceImageView startAnimating];
    }else{
        [self.voiceImageView stopAnimating];
    }
}

- (void)addVoiceView{
    
    UIImage * image = [UIImage nim_imageInKit:@"session_sender_audio"];
    _voiceImageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_voiceImageView];
    
    _durationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _durationLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_durationLabel];
    
}
//Jersey IM:刷新,
- (void)refresh:(NIMMessageModel *)data{
    [super refresh:data];
    
    [self refreshVoiceView];
    
    NIMAudioObject *object = (NIMAudioObject *)self.model.message.messageObject;
    self.durationLabel.text = [NSString stringWithFormat:@"%zd\"",(object.duration+500)/1000];//四舍五入
    //Jersey IM: 取出 setting作相应配置.
    NIMKitSetting *setting = [[NIMKit sharedKit].config setting:data.message];

    self.durationLabel.font      = setting.font;
    self.durationLabel.textColor = setting.textColor;
    //Jersey IM: 重新设置左右语音图,和动画图.
    
    [self.durationLabel sizeToFit];
    
    [self setPlaying:self.isPlaying];
}

- (void)refreshVoiceView {
    
    [_voiceImageView removeFromSuperview];
    NSString* userID = [[[NIMSDK sharedSDK] loginManager] currentAccount];
    BOOL isMySender = [self.model.message.from isEqualToString:userID];
    if (isMySender) {
        UIImage * image = [UIImage nim_imageInKit:@"session_sender_audio"];
        _voiceImageView = [[UIImageView alloc] initWithImage:image];
        NSArray* imageNames = @[@"session_sender_audio_animationA",@"session_sender_audio_animationB",@"session_sender_audio_animationC"];
        NSMutableArray* animationImages = [[NSMutableArray alloc] init];
        for (NSString* imageName in imageNames) {
            [animationImages addObject:[UIImage imageNamed:imageName]];
        }
        _voiceImageView.animationImages = animationImages;
        _voiceImageView.animationDuration = 1.0;
    } else {
        UIImage * image = [UIImage nim_imageInKit:@"session_receiver_audio"];
        _voiceImageView = [[UIImageView alloc] initWithImage:image];
        
        NSArray* imageNames = @[@"session_receiver_audio_animationA",@"session_receiver_audio_animationB",@"session_receiver_audio_animationC"];
        NSMutableArray* animationImages = [[NSMutableArray alloc] init];
        for (NSString* imageName in imageNames) {
            UIImage* image = [UIImage imageNamed:imageName];
            [animationImages addObject:image];
        }
        _voiceImageView.animationImages = animationImages;
        _voiceImageView.animationDuration = 1.0;
    }
    [self addSubview:_voiceImageView];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    //Jersey IM:使用消息排列的方式来判断左右.
    //IMTODO: 动画效果有问题,重新切图.
    UIEdgeInsets contentInsets = self.model.contentViewInsets;
    if (self.model.message.isOutgoingMsg) {
        self.voiceImageView.nim_right = self.nim_width - contentInsets.right;
        _durationLabel.nim_left = contentInsets.left;
    } else
    {
       self.voiceImageView.nim_left = contentInsets.left;
        _durationLabel.nim_right = self.nim_width - contentInsets.right;
    }
    _voiceImageView.nim_centerY = self.nim_height * .5f;
    _durationLabel.nim_centerY = _voiceImageView.nim_centerY;
    
}

-(void)onTouchUpInside:(id)sender
{
    if ([self.model.message attachmentDownloadState]== NIMMessageAttachmentDownloadStateFailed
        || [self.model.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateNeedDownload) {
        if (self.audioUIDelegate && [self.audioUIDelegate respondsToSelector:@selector(retryDownloadMsg)]) {
            [self.audioUIDelegate retryDownloadMsg];
        }
        return;
    }
    if ([self.model.message attachmentDownloadState] == NIMMessageAttachmentDownloadStateDownloaded) {
        
        if ([[NIMSDK sharedSDK].mediaManager isPlaying]) {
            [self stopPlayingUI];
        }
        //Jersey IM: 按钮名称
        NIMKitEvent *event = [[NIMKitEvent alloc] init];
        event.eventName = NIMKitEventNameTapAudio;
        event.messageModel = self.model;
        [self.delegate onCatchEvent:event];

    }
}

#pragma mark - NIMMediaManagerDelegate

- (void)playAudio:(NSString *)filePath didBeganWithError:(NSError *)error {
    if(filePath && !error) {
        if (self.isPlaying && [self.audioUIDelegate respondsToSelector:@selector(startPlayingAudioUI)]) {
            [self.audioUIDelegate startPlayingAudioUI];
        }        
    }
}

- (void)playAudio:(NSString *)filePath didCompletedWithError:(NSError *)error
{
    [self stopPlayingUI];
}

#pragma mark - private methods
- (void)stopPlayingUI
{
    [self setPlaying:NO];
}

- (BOOL)isPlaying
{
    return [NIMKitAudioCenter instance].currentPlayingMessage == self.model.message; //对比是否是同一条消息，严格同一条，不能是相同ID，防止进了会话又进云端消息界面，导致同一个ID的云消息也在动画
}

#pragma mark -- SET GET

@end
