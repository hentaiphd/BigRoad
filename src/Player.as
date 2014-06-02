package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/ship.png")] private var ImgPlayer:Class;

        public var _money:Number = 500;
        public var _age:Number = 35;
        public var _yearsTraveled:Number = 0;
        public var _grounded:Boolean = false;
        public var _deduction:Number = 100;
        public var timeSec:Number = 0;
        public var timeFrame:Number = 0;
        public var deduct:Boolean = false;
        public var deductcounter:Number = 0;
        public var _angle:Number = 0;
        public var flightDirection:DHPoint = null;
        public var freeFlightTime:Number = 0;

        public var __targetPlanet:Planet = null;

        public var _attachedPlanet:Planet = null;

        public static var STATE_ATTACHED:Number = 0;
        public static var STATE_FREE:Number = 1;
        public static var STATE_HOMING:Number = 2;
        public var _state:Number = STATE_ATTACHED;

        public var _debugText:FlxText;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPlayer,false,false,17,42);
            this.scale.y = -1;

            this._debugText = new FlxText(200, 200, FlxG.width, "");
            this._debugText.size = 14;
            FlxG.state.add(_debugText);
        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if (this._state == STATE_ATTACHED) {
            } else if (this._state == STATE_FREE) {
                this.freeFlightTime += 1;
                this.x += flightDirection.x;
                this.y += flightDirection.y;

                if (this.freeFlightTime > 30) {
                    this.homeToPlanet(this.__targetPlanet);
                }
            } else if (this._state == STATE_HOMING) {
                this.x += flightDirection.x;
                this.y += flightDirection.y;

                // tilt toward target planet
                var xDisp:Number = this.__targetPlanet.x - this.x;
                var yDisp:Number = this.__targetPlanet.y - this.y;
                var angleToTarget:Number = _angle - Math.atan(xDisp / yDisp);
                this._debugText.text = "" + angleToTarget;

                var turnAngle:Number;
                turnAngle = angleToTarget / 90;

                this._angle = angleToTarget;
                this.flightDirection = new DHPoint(Math.sin(turnAngle)*3, Math.cos(turnAngle)*3);
                this.flightDirection = new DHPoint(xDisp*.1, yDisp*.1);

                if(xDisp < 1){
                    if(yDisp < 1){
                        this.attach(__targetPlanet);
                    }
                }
            }

            this.angle = _angle*(180/Math.PI)*-1;
            this._angle %= 2*Math.PI;
        }

        public function arrowPressed(_left:Boolean=true):void {
            if (_state == STATE_ATTACHED) {
                var newPos:DHPoint = this.getVectorToAttachedPlanet();
                newPos.x += this._attachedPlanet.x + 10;
                newPos.y += this._attachedPlanet.y + 5;
                this.x = newPos.x;
                this.y = newPos.y;

                if (_left) {
                    this._angle += (Math.PI*2)/100;
                } else {
                    this._angle -= (Math.PI*2)/100;
                }
            }
        }

        public function getVectorToAttachedPlanet():DHPoint {
            var newPos:DHPoint = new DHPoint(this._attachedPlanet._radius*Math.sin(_angle),
                                             this._attachedPlanet._radius*Math.cos(_angle));
            return newPos;
        }

        private function _setState(s:Number):void {
            this._state = s;
        }

        public function attach(p:Planet):void {
            this._attachedPlanet = p;
            this._setState(STATE_ATTACHED);
        }

        public function detach():void {
            this.freeFlightTime = 0;
            this.flightDirection = this.getVectorToAttachedPlanet();
            this.flightDirection.x *= .1;
            this.flightDirection.y *= .1;
            this._attachedPlanet = null;
            this._setState(STATE_FREE);
        }

        public function homeToPlanet(p:Planet):void {
            this._setState(STATE_HOMING);
        }
    }
}
