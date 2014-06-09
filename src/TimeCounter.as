package {
    import org.flixel.*;

    public class TimeCounter {
        [Embed(source="../assets/icons.png")] private var ImgIcons:Class;

        public var frame_lifetime:Number;
        public var frames_remaining:Number;
        public var total_frames:Number;

        public var origin:FlxPoint;
        public var running:Boolean = true;
        public var width:Number;

        public var pieces:Array;
        public static var NUM_SEGMENTS:Number = 60;
        public var segment_width:Number = 10;

        public var endIcon:FlxSprite, curIcon:FlxSprite;

        public var last_index:Number = NUM_SEGMENTS - 1;

        public function TimeCounter(origin:FlxPoint, width:Number) {
            this.pieces = new Array();
            this.frames_remaining = this.total_frames;
            this.segment_width = width / NUM_SEGMENTS;
            this.width = width;
            for (var i:int = 0; i < NUM_SEGMENTS; i++) {
                var segment:FlxSprite = new FlxSprite(origin.x+((this.segment_width-1)*i), origin.y);
                segment.makeGraphic(this.segment_width, 5, 0xffff4949);
                FlxG.state.add(segment);
                this.pieces.push(segment);
            }

            endIcon = new FlxSprite(origin.x, origin.y);
            endIcon.loadGraphic(ImgIcons, true, true, 24, 24, true);
            endIcon.addAnimation("galaxy", [0], 1, false);
            FlxG.state.add(endIcon);
            endIcon.x = origin.x - endIcon.width/2;
            endIcon.y = origin.y - endIcon.height/2;
            endIcon.play("galaxy");

            curIcon = new FlxSprite(origin.x, origin.y);
            curIcon.loadGraphic(ImgIcons, true, true, 24, 24, true);
            curIcon.addAnimation("bee", [1], 1, false);
            FlxG.state.add(curIcon);
            curIcon.play("bee");
        }

        public function set_time(frames:Number):void {
            this.frames_remaining = frames;
            this.total_frames = frames;
        }

        public function set_color(color:int):void {
            for (var i:int = 0; i < this.pieces.length; i++) {
                this.pieces[i].color = color;
            }
        }

        public function update():void {
            if (this.running) {
                this.frame_lifetime++;
                if (this.frames_remaining > 0) {
                    this.frames_remaining--;
                }
            }

            var greatest_x:Number = 0;
            var last_visible:FlxSprite = null;

            var pct:Number = this.frames_remaining / this.total_frames;
            var per_segment:Number = this.total_frames / NUM_SEGMENTS;
            for (var i:int = 0; i < this.pieces.length; i++) {
                var flr:Number = i*per_segment;
                var cil:Number = (i+1)*per_segment
                var piece:FlxSprite = this.pieces[i];
                if (this.frames_remaining > flr) {
                    piece.alpha = 1;
                    if (this.pieces[i].x > greatest_x){
                        greatest_x = this.pieces[i].x;
                        last_visible = this.pieces[i];
                    }
                } else {
                    piece.alpha = 0;
                }
            }

            if (last_visible != null) {
                curIcon.x = last_visible.x - curIcon.width/2;
                curIcon.y = last_visible.y - curIcon.height/2;
            }
        }
    }
}
