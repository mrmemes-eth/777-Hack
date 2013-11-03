#import "WelcomeScene.h"
#import "BoardScene.h"

static const CGFloat kMargin = 20;

@implementation WelcomeScene {
  SKLabelNode *_nameLabel;
  SKLabelNode *_startLabel;
}

-(id)initWithSize:(CGSize)size {    
  if (self = [super initWithSize:size]) {
    [self setBackgroundColor:[SKColor blackColor]];
    [self addChild:self.nameLabel];
    [self addChild:self.startLabel];
  }
  return self;
}

-(SKLabelNode *)nameLabel {
  if (!_nameLabel) {
    _nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    [_nameLabel setText:@"777-Hack"];
    [_nameLabel setFontSize:30];
    [_nameLabel setFontColor:[SKColor greenColor]];
    [_nameLabel setPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
  }
  return _nameLabel;
}

-(SKLabelNode *)startLabel {
  if (!_startLabel) {
    _startLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    [_startLabel setText:@"START"];
    [_startLabel setFontSize:36];
    [_startLabel setFontColor:[SKColor greenColor]];
    [_startLabel setPosition:CGPointMake(self.nameLabel.position.x, self.nameLabel.position.y - _startLabel.frame.size.height - kMargin)];
    [_startLabel setName:@"start_label"];
  }
  return _startLabel;
}

-(void)didMoveToView:(SKView *)view {
  SKAction *blink = [SKAction sequence:@[[SKAction fadeOutWithDuration:0.75],
                                         [SKAction fadeInWithDuration:0.75]]];
  SKAction *blinkForever = [SKAction repeatActionForever:blink];
  [self.startLabel runAction:blinkForever];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  CGPoint location = [touch locationInNode:self];
  SKNode *node = [self nodeAtPoint:location];
  if ([node.name isEqualToString:@"start_label"]) {
    SKScene *boardScene  = [[BoardScene alloc] initWithSize:self.size];
    SKTransition *transition = [SKTransition fadeWithDuration:1];
    [self.view presentScene:boardScene transition:transition];
  }
}

@end
