#import "WelcomeScene.h"
#import "BoardScene.h"

@implementation WelcomeScene {
  SKLabelNode *_nameLabel;
}

-(id)initWithSize:(CGSize)size {    
  if (self = [super initWithSize:size]) {
    [self setBackgroundColor:[SKColor blackColor]];
    [self addChild:self.nameLabel];
  }
  return self;
}

-(SKLabelNode *)nameLabel {
  if (!_nameLabel) {
    _nameLabel = [SKLabelNode labelNodeWithFontNamed:@"Courier-Bold"];
    [_nameLabel setText:@"777-Hack"];
    [_nameLabel setFontSize:30];
    [_nameLabel setFontColor:[SKColor greenColor]];
    [_nameLabel setPosition:CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame))];
  }
  return _nameLabel;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  SKScene *boardScene  = [[BoardScene alloc] initWithSize:self.size];
  SKTransition *fade = [SKTransition fadeWithDuration:0.25];
  [self.view presentScene:boardScene transition:fade];
}

@end
