package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Projectile {
        public var body:b2Body = null;
        public var spr:FlxSprite = null;
        public var m_world:b2World;
        public var inactive:Boolean = false;

        public var x:Number, y:Number;
        public var width:Number, height:Number;

        public function Projectile(world:b2World) {
            x = 0;
            y = 0;
            width = 10;
            height = 10;

            spr = new FlxSprite(0, 0);
            spr.makeGraphic(width, height, 0xff0000ff);
            FlxG.state.add(spr);

            m_world = world;
        }

        public function update(origin:FlxPoint, launchAngle:Number):void {
            spr.update();

            if (body != null) {
                x = ((body.GetPosition().x / FlxG.camera.zoom) * PlayState.m_physScale) - spr.width/2;
                y = ((body.GetPosition().y / FlxG.camera.zoom) * PlayState.m_physScale) - spr.height/2;
                spr.angle = body.GetAngle() / (Math.PI/180);
            } else {
                x = origin.x + 20*Math.sin((launchAngle) * (Math.PI/180));
                y = origin.y + 20*Math.cos((launchAngle) * (Math.PI/180));
            }

            spr.x = x;
            spr.y = y;

            if (x > FlxG.width || x < 0 || y < 0) {
                destroy();
            }
        }

        public function launch(angle:Number):void {
            var bd:b2BodyDef = new b2BodyDef();
            bd.type = b2Body.b2_dynamicBody;
            var box:b2PolygonShape = new b2PolygonShape();
            box.SetAsBox(width / PlayState.m_physScale, height / PlayState.m_physScale);
            var fixtureDef:b2FixtureDef = new b2FixtureDef();
            fixtureDef.shape = box;
            fixtureDef.density = 1.0;
            fixtureDef.friction = 0.4;
            fixtureDef.restitution = 0.9;
            bd.position.Set((x * FlxG.camera.zoom) / PlayState.m_physScale, (y * FlxG.camera.zoom) / PlayState.m_physScale);
            bd.angle = 3;
            body = m_world.CreateBody(bd);
            body.CreateFixture(fixtureDef);

            var vel:b2Vec2 = new b2Vec2(2*Math.sin(angle * (Math.PI/180)),
                                        2*Math.cos(angle * (Math.PI/180)));
            body.ApplyImpulse(vel, body.GetPosition());
        }

        public function destroy():void {
            inactive = true;
            FlxG.state.remove(spr);
            m_world.DestroyBody(body);
        }
    }
}