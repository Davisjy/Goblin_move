//
//  GameScene.m
//  01-Goblin
//
//  Created by qingyun on 16/1/2.
//  Copyright (c) 2016年 qingyun. All rights reserved.
//

#import "GameScene.h"

@interface GameScene ()
{
    NSArray *_walkArr;
    NSArray *_goblinArr;
    
    SKSpriteNode *_goblin;
}
@end

@implementation GameScene

- (NSArray *)loadTextureAtlasWithName:(NSString *)name prefixName:(NSString *)preName Count:(NSInteger)count
{
    NSMutableArray *temArr = [NSMutableArray array];
    // 1. 实例化纹理图集
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:name];
    //        NSLog(@"%@", atlas.textureNames);
    // 2. 加载纹理数组
    for (int i = 1; i <= count; i ++) {
        NSString *fileName = [NSString stringWithFormat:@"%@_%04d", preName, i];
        SKTexture *texture = [atlas textureNamed:fileName];
        
        [temArr addObject:texture];
    }
    return temArr;
}

- (void)loadAnimationWithArray:(NSArray *)arr
{
    SKAction *anim = [SKAction animateWithTextures:arr timePerFrame:0.1f];
    [_goblin runAction:[SKAction repeatActionForever:anim]];
}

- (instancetype)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        // 1. 实例化纹理图集
        _goblinArr = [self loadTextureAtlasWithName:@"Goblin_Idle" prefixName:@"goblin_idle" Count:28];
        // 3. 实例化小妖精
        _goblin = [SKSpriteNode spriteNodeWithTexture:_goblinArr[0]];
        _goblin.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [self addChild:_goblin];
        
        // 4. 加载小妖精发呆动画
        [self loadAnimationWithArray:_goblinArr];
    }
    return self;
}

// 开始扭转小妖精的方向
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInNode:self];
    
    // 偏移数据
    CGPoint offset = CGPointMake(location.x - _goblin.position.x, location.y - _goblin.position.y);
    
    // 计算偏移角度
    CGFloat angle = atan2f(offset.y, offset.x);
    
    _goblin.zRotation = angle - M_PI_2;
    
    // 小妖精行走
    // 1. 停止之前的发呆动画
    [_goblin removeAllActions];
    
    // 2. 添加行走动画
    _walkArr = [self loadTextureAtlasWithName:@"Goblin_Walk" prefixName:@"goblin_walk" Count:28];
    [self loadAnimationWithArray:_walkArr];
    
    // 3. 开始行走行为
    // 设置固定速度为穿过竖屏是一秒
    CGFloat velocity = self.size.height / 5;
    CGFloat dis = sqrtf(powf(offset.x, 2.0) + powf(offset.y, 2.0));
    NSTimeInterval duration = dis / velocity;
    SKAction *move = [SKAction moveTo:location duration:duration];
    
    // 4. 行走完成恢复发呆
    [_goblin runAction:move completion:^{
        [_goblin removeAllActions];
        [self loadAnimationWithArray:_goblinArr];
    }];
    
}
@end
