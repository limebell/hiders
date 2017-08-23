package game.db {
	import flash.text.TextFormat;
	import flash.text.Font;
	
	public class FontDB {
		private static var fonts:Object;
		public static const
		NBareun:String = "nanumbareunlight",
		NPen:String = "nanumpen";

		{
			fonts = new Object();
			fonts.nanumbareunlight = new Font_NanumbareunLight();
			fonts.nanumpen = new Font_Nanumpen();
		}
		
		public static function getFontName(font:String):String {
			return fonts[font].fontName;
		}

	}
	
}
