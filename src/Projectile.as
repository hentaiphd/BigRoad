package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    public class Projectile {
        [Embed(source="../assets/plushies.png")] private var ImgPlushie:Class;
        public var body:b2Body = null;
        public var spr:FlxSprite = null;
        public var m_world:b2World;
        public var inactive:Boolean = false;

        public var x:Number, y:Number;
        public var width:Number, height:Number;

        public var spin:Boolean = false;

        public function Projectile(world:b2World) {
            x = 0;
            y = 0;
            width = 32;
            height = 32;

            spr = new FlxSprite(0, 0);
            var rand:Number = Math.floor(Math.random()*3);
            spr.loadGraphic(ImgPlushie, true, false, width, height);
            spr.addAnimation("plush",[rand],1,false);
            spr.play("plush");
            FlxG.state.add(spr);

            m_world = world;
        }

        public function update(origin:FlxPoint=null, launchAngle:Number=0):void {
            spr.update();

            if (body != null) {
                x = ((body.GetPosition().x / FlxG.camera.zoom) * PlayState.m_physScale) - spr.width/2;
                y = ((body.GetPosition().y / FlxG.camera.zoom) * PlayState.m_physScale) - spr.height/2;
                spr.angle = body.GetAngle() / (Math.PI/180);
            } else {
                x = origin.x + 20*Math.sin((launchAngle) * (Math.PI/180));
                y = origin.y + 20*Math.cos((launchAngle) * (Math.PI/180));
            }

            if (x > FlxG.width/FlxG.camera.zoom || x < 0 || y < 0) {
                destroy();
            }

            if(spin){
                spr.angle += 5;
                spr.scale.x -= .01;
                spr.scale.y -= .01;
                spr.y++;

                if(spr.scale.x <= 0){
                    if(spr.scale.y <= 0){
                        destroy();
                    }
                }
            } else {
                spr.x = x;
                spr.y = y;
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

            var vel:b2Vec2 = new b2Vec2(3*Math.sin(angle * (Math.PI/180)),
                                        3*Math.cos(angle * (Math.PI/180)));
            body.ApplyImpulse(vel, body.GetPosition());
        }

        public function collided():void{
            spin = true;
        }

        public function destroy():void {
            inactive = true;
            FlxG.state.remove(spr);
            if (body != null) {
                m_world.DestroyBody(body);
            }
        }
    }
}
