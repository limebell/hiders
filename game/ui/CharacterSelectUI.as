package game.ui {
	import game.db.CharacterDB;
	import game.db.CharacterData;
	import game.db.FontDB;
	import game.db.SkillData;
	
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;
	import flash.filters.GlowFilter;
	
	public class CharacterSelectUI extends MovieClip {
		private var _index:int;
		private var _clip:MovieClip;
		private var _textFormat:TextFormat;
		
		private var _character:CharacterData;
		private var _portrait:MovieClip;
		private var _portraitField:MovieClip;
		private var _name:TextField;
		private var _status:TextField;
		private var _description:TextField;
		private var _skill:SkillData;
		private var _skillName:TextField;
		private var _skillText:TextField;
		
		private var _leftbtn:MovieClip;
		private var _rightbtn:MovieClip;

		public function CharacterSelectUI() {
			_clip = new characterSelectUIClip();
			this.addChild(_clip);
			_leftbtn = _clip.leftbtn;
			_rightbtn = _clip.rightbtn;
			
			_textFormat = new TextFormat(FontDB.getFontName(FontDB.NBareun));
			_textFormat.align = "center";
			_textFormat.leading = 7;
			
			_portraitField = new MovieClip();
			
			_name = new TextField();
			_skillName = new TextField();
			_skillText = new TextField();
			_status = new TextField();
			_description = new TextField();
			
			_textFormat.size = 20;
			_textFormat.bold = true;
			_name.defaultTextFormat = _textFormat;
			_name.filters = [new GlowFilter(0xffffffff, 1, 2, 2, 10, 3)];
			_textFormat.size = 18;
			_textFormat.bold = false;
			_skillName.defaultTextFormat = _textFormat;
			_textFormat.size = 15;
			_skillText.defaultTextFormat = _textFormat;
			_textFormat.size = 20;
			_status.defaultTextFormat = _textFormat;
			_textFormat.align = "left";
			_description.defaultTextFormat = _textFormat;
			
			this.addChild(_portraitField);
			this.addChild(_name);
			this.addChild(_skillName);
			this.addChild(_skillText);
			this.addChild(_status);
			this.addChild(_description);
			
			_name.mouseEnabled = _skillName.mouseEnabled = _skillText.mouseEnabled = _status.mouseEnabled = _description.mouseEnabled = false;
			_name.width = _skillName.width = _skillText.width = 200;
			_status.width = _description.width = 1000;
			_description.height = 150;
			
			_name.x = -_name.width/2;
			_skillName.x = -_skillName.width/2;
			_skillText.x = -_skillText.width/2;
			_status.x = -_status.width/2;
			_description.x = -_description.width/2;
			
			_name.y = -140;
			_skillName.y = -85;
			_skillText.y = -60;
			_status.y = 20;
			_description.y = 85;
			_skillText.wordWrap = _description.wordWrap = true;
			
			_leftbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			_rightbtn.addEventListener(MouseEvent.CLICK, clickHandler);
			
			changeCharacterTo(0);
		}
		
		private function clickHandler(e:MouseEvent):void {
			switch(e.target){
				case _leftbtn:
					if(_index != 0) changeCharacterTo(_index-1);
					break;
				case _rightbtn:
					if(_index != CharacterDB.getNumChars()-1) changeCharacterTo(_index+1);
					break;
			}
		}
		
		private function changeCharacterTo(index:int) {
			_index = index;
			_character = CharacterDB.getCharacterAt(index);
			_skill = _character.skill;
			
			if(_portrait != null) _portraitField.removeChild(_portrait);
			
			_portrait = _character.clip;
			_portraitField.addChild(_portrait);
			_portrait.gotoAndStop("portrait");
			_portrait.y = -210;
			
			_name.text = _character.charName;
			_skillName.text = _skill.skillName;
			_skillText.text = _skill.description;
			_status.text ="ATK : "+_character.baseATK+", DEF : "+_character.baseDEF+", HP : "+_character.baseHP+", ST : "+_character.baseST;
			_description.text = _character.description;
		}
		
		public function get index():int {
			return _index;
		}

	}
	
}
