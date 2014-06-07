package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Launcher extends FlxSprite{
        public var curProjectile:b2Body = null;
        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var m_world:b2World;

        public var baseSprite:FlxSprite;
        public var armSprite:FlxSprite;
        public var projectileSprite:FlxSprite;

        public var throwAngle:Number = 90;
        public var rotateBack:Boolean = false;

        public function Launcher(world:b2World) {
            m_world = world;

            x = 20;
            y = 100;

            baseSprite = new FlxSprite(x, y);
            baseSprite.makeGraphic(40, 80, 0xffff0000);
            FlxG.state.add(baseSprite);

            armSprite = new FlxSprite(x, y);
            armSprite.makeGraphic(10, 30, 0xff00ff00);
            FlxG.state.add(armSprite);

            projectileSprite = new FlxSprite(x, y);
            projectileSprite.makeGraphic(10, 10, 0xff0000ff);
            FlxG.state.add(projectileSprite);
        }

        override public function update():void {
            timeFrame++;
            if(timeFrame % 50 == 0){
                timeSec++;
            }

            baseSprite.update();
            armSprite.update();
            projectileSprite.update();

            setPosition(new DHPoint(FlxG.mouse.x, y));

            if(FlxG.mouse.pressed()) {
                if(timeFrame % 20 == 0) {
                    throwAngle += (rotateBack ? -1 : 1) * 36;
                }
                if (throwAngle >= 180+90) {
                    rotateBack = true;
                } else if(throwAngle <= 90) {
                    rotateBack = false;
                }
            }

            armSprite.angle = 180 - throwAngle;

            projectileSprite.x = x + 40*Math.sin((throwAngle) * (Math.PI/180));
            projectileSprite.y = y + 40*Math.cos((throwAngle) * (Math.PI/180));

            if (FlxG.mouse.justReleased()) {
                launchProjectile();
            }
        }

        public function setPosition(pos:DHPoint):void {
            x = pos.x;
            y = pos.y;

            baseSprite.x = x;
            baseSprite.y = y;

            armSprite.x = x;
            armSprite.y = y;
        }

        public function launchProjectile():void {
            var bd:b2BodyDef = new b2BodyDef();
            bd.type = b2Body.b2_dynamicBody;
            var box:b2PolygonShape = new b2PolygonShape();
            box.SetAsBox(30 / PlayState.m_physScale, 30 / PlayState.m_physScale);
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.shape = box;
            fixtureDef.density = 1.0;
            fixtureDef.friction = 0.4;
            fixtureDef.restitution = 0.9;
            bd.position.Set(x / PlayState.m_physScale, y / PlayState.m_physScale);
            bd.angle = 3;
            curProjectile = m_world.CreateBody(bd);
            curProjectile.CreateFixture(fixtureDef);

            var vel:b2Vec2 = new b2Vec2(40*Math.sin(throwAngle * (Math.PI/180)),
                                 40*Math.cos(throwAngle * (Math.PI/180)));
            curProjectile.ApplyImpulse(vel, curProjectile.GetPosition());
        }
    }
}
