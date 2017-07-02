package game.db {
	import flash.text.TextFormat;
	import game.asset.Font_HYShin;
	import flash.text.Font;
	
	public class FontDB {
		private static var fonts:Vector.<Font>;

		{
			fonts = new Vector.<Font>();
			fonts.push(new Font_HYShin());
		}
		
		public static function getFontName(index:int):String {
			return fonts[index].fontName;
		}

	}
	
}
