package {
    import org.flixel.*;

    import Box2D.Dynamics.*;
    import Box2D.Collision.*;
    import Box2D.Collision.Shapes.*;
    import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;

    import flash.utils.setTimeout;

    public class Launcher extends FlxSprite{
        [Embed(source="../assets/dad.png")] private var ImgDad:Class;
        [Embed(source="../assets/dad_arm.png")] private var ImgDadArm:Class;
        [Embed(source="../assets/throw.mp3")] private var SndThrow:Class;

        public var timeFrame:Number = 0;
        public var timeSec:Number = 0;
        public var m_world:b2World;

        public var baseSprite:FlxSprite;
        public var armSprite:FlxSprite;
        public var projectiles:Array;
        public var curProjectile:Projectile;
        public var originY:Number;

        public var rotateBack:Boolean = false;
        public var armDrawAngle:Number;
        public var thisThrowAngle:Number;
        public var throwStartAngle:Number;
        public var armDrawAngleArc:Number;
        public var lastLaunchTime:Number = 0;

        public static const STATE_WINDUP:Number = 0;
        public static const STATE_RELEASE:Number = 1;
        public static const STATE_IDLE:Number = 2;
        public static const STATE_COOLDOWN:Number = 3;
        public static const STATE_WIGGLE:Number = 4;
        public var _state:Number = STATE_IDLE;

        public var _active:Boolean = true;

        public var debugText:FlxText;

        public function Launcher(world:b2World) {
            m_world = world;
            projectiles = new Array();

            x = 20;
            y = originY = 50;

            throwStartAngle = armDrawAngle = 155;
            armDrawAngleArc = 35;

            baseSprite = new FlxSprite(x, y);
            baseSprite.loadGraphic(ImgDad, true, true, 48, 48, true);
            baseSprite.addAnimation("rest", [1], 1, false);
            baseSprite.addAnimation("throw", [0], 1, false);
            baseSprite.play("rest")
            FlxG.state.add(baseSprite);

            armSprite = new FlxSprite(x, y);
            armSprite.loadGraphic(ImgDadArm, true, true, 8, 64, true);
            armSprite.visible = false;
            FlxG.state.add(armSprite);

            curProjectile = new Projectile(m_world);
            curProjectile.spr.alpha = 0;

            debugText = new FlxText(100,100,100,"");
            FlxG.state.add(debugText);

            baseSprite.alpha = 0;
            armSprite.alpha = 0;
        }

        override public function update():void {
            timeFrame++;
            if(timeFrame % 50 == 0){
                timeSec++;
            }

            for (var i:int = 0; i < projectiles.length; i++) {
                var projectile:Projectile = projectiles[i];
                projectile.update();

                if (projectile.inactive) {
                    projectiles.splice(projectiles.indexOf(projectile), 1);
                }
            }

            if (!_active) return;

            setPosition(new DHPoint(FlxG.mouse.x, originY + Math.sin(timeFrame*.05)*5));

            if (_state == STATE_IDLE) {
                if(FlxG.mouse.pressed()) {
                    _state = STATE_WINDUP;
                    baseSprite.play("throw");
                    armSprite.visible = true;
                    armDrawAngle = 0;
                }
            } else if (_state == STATE_WIGGLE) {
                if (!FlxG.mouse.pressed()) {
                    _state = STATE_RELEASE;
                    FlxG.play(SndThrow, .7);
                    thisThrowAngle = armDrawAngle + 180;
                }
                if(timeFrame % 3 == 0) {
                    armDrawAngle += (rotateBack ? -1 : 1) * 25;
                }
                if (armDrawAngle >= throwStartAngle + armDrawAngleArc) {
                    rotateBack = true;
                } else if(armDrawAngle <= throwStartAngle) {
                    rotateBack = false;
                }
            } else if (_state == STATE_WINDUP) {
                if (!FlxG.mouse.pressed()) {
                    _state = STATE_RELEASE;
                    FlxG.play(SndThrow, .7);
                    armDrawAngle = 0;
                    thisThrowAngle = 90;
                }
                if(timeFrame % 5 == 0) {
                    armDrawAngle -= 30;
                }
                if (armDrawAngle < 0) {
                    armDrawAngle = 360 + armDrawAngle;
                }
                if (armDrawAngle > throwStartAngle && armDrawAngle < throwStartAngle + armDrawAngleArc) {
                    _state = STATE_WIGGLE;
                }
            } else if (_state == STATE_RELEASE) {
                if (armDrawAngle < thisThrowAngle) {
                    if (timeFrame % 2 == 0) {
                        armDrawAngle += 50;
                    }
                } else {
                    launchProjectile(armDrawAngle);
                    lastLaunchTime = timeFrame;
                    _state = STATE_COOLDOWN;
                }
            } else if (_state == STATE_COOLDOWN) {
                if (timeFrame - lastLaunchTime == 30) {
                    _state = STATE_IDLE;
                    resetArm();
                }
            }

            armSprite.x = baseSprite.x + 19;
            armSprite.y = baseSprite.y - 20;
            armSprite.angle = 180 - armDrawAngle;
            curProjectile.update(new FlxPoint(x+13, y), armDrawAngle);
        }

        public function resetArm():void {
            try {
                baseSprite.play("rest");
            } catch (err:Error) {
            }
            armSprite.visible = false;
        }

        public function setPosition(pos:DHPoint):void {
            if (pos.x > 0 && pos.x < (FlxG.width-50) / FlxG.camera.zoom) {
                x = pos.x;
                y = pos.y;

                baseSprite.x = x;
                baseSprite.y = y;

                armSprite.x = x;
                armSprite.y = y;
            }
        }

        public function fadeOut():void{
            baseSprite.alpha -= .01;
            armSprite.alpha -= .01;
            curProjectile.spr.alpha -= .01;

            for (var j:Number = 0; j < projectiles.length; j++) {
                var proj:Projectile = projectiles[j];
                proj.destroy();
            }
            projectiles.length = 0;
        }

        public function fadeIn():void{
            baseSprite.alpha += .01;
            armSprite.alpha += .01;
            curProjectile.spr.alpha += .01;
        }

        public function launchProjectile(angle:Number):void {
            curProjectile.launch(angle);
            projectiles.push(curProjectile);
            curProjectile = new Projectile(m_world);
        }

        public function testTargetCollide(tar:GroundTarget, _callback:Function):void {
            for (var j:Number = 0; j < projectiles.length; j++) {
                var proj:FlxSprite = projectiles[j].spr;
                FlxG.overlap(tar, proj, _callback);
                FlxG.overlap(tar, proj, targetCollide);
            }
        }

        public function targetCollide(tar:GroundTarget, p:FlxSprite):void {
            var proj:Projectile = getProjectileFromSprite(p);
            if (proj) {
                proj.collided();
            }
        }

        public function getProjectileFromSprite(spr:FlxSprite):Projectile {
            for(var i:int = 0; i < projectiles.length; i++) {
                var p:Projectile = projectiles[i];
                if (p.spr == spr) {
                    return p;
                }
            }
            return null;
        }
    }
}
