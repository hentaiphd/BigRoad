package
{
    import org.flixel.*;

    public class Player extends FlxSprite{
        [Embed(source="../assets/person.png")] private var ImgPerson:Class;

        public var _money:Number = 500;
        public var _age:Number = 35;
        public var _yearsTraveled:Number = 0;
        public var _grounded:Boolean = false;
        public var _deduction:Number = 100;
        public var timeSec:Number = 0;
        public var timeFrame:Number = 0;
        public var deduct:Boolean = false;
        public var deductcounter:Number = 0;

        public function Player(x:int,y:int):void{
            super(x,y);
            loadGraphic(ImgPerson,false,false,17,55);
        }

        override public function update():void{
            super.update();
            timeFrame++;
            if(timeFrame%50 == 0){
                timeSec++;
            }

            if(!_grounded){
                if(timeFrame%250 == 0){
                    _age++;
                    _yearsTraveled++;
                    deduct = true;
                }
            }

            if(deduct){
                _money--;

                if(deductcounter < _deduction){
                    deductcounter++;
                } else {
                    deductcounter = 0;
                    deduct = false;
                }
            }
        }
    }
}