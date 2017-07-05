package game.db {
	import flash.text.TextFormat;
	import flash.text.Font;
	
	public class FontDB {
		private static var fonts:Object;
		public static const
		HYShin:String = "hy_shin",
		NBareun:String = "nanumbareunlight";

		{
			fonts = new Object();
			fonts.hy_shin = new Font_HYShin();
			fonts.nanumbareunlight = new Font_NanumbareunLight();
		}
		
		public static function getFontName(font:String):String {
			return fonts[font].fontName;
		}

	}
	
}
