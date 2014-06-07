package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Launcher extends FlxSprite {
        public var curProjectile:b2Body = null;
        public var m_world:b2World;

        public function Launcher(world:b2World) {
            super(20, 100);

            m_world = world;

            makeGraphic(10, 10, 0xffff0000);
        }

        override public function update():void {
            super.update();

            x = FlxG.mouse.x;

            if (FlxG.mouse.justReleased()) {
                launchProjectile();
            }
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

            curProjectile.ApplyImpulse(new b2Vec2(10, -40), curProjectile.GetPosition());
        }
    }
}
