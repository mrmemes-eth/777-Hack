@interface SpriteSectorNode : SKSpriteNode
+(id)nodeWithSector:(Sector)sector;
-(Sector)sector;
-(void)setSector:(Sector)sector;
@end
