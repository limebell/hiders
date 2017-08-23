package game.db {
	import flash.display.MovieClip;
	
	public class JobDB {
		
		private static var jobs:Vector.<JobData>;

		{
			jobs = new Vector.<JobData>();
			
			addJob("소방관",
							"최종 체력이 10퍼센트 증가합니다.",
							4, 7, 120, 100, "portrait_firefighter");
			
			addJob("경찰",
							"총을 무기로 사용할 수 있습니다.",
							3, 3, 80, 80, "portrait_police");
		}
		
		private static function addJob(jobName:String, description:String, baseATK:int, baseDEF:int, baseHP:int, baseST:int, clip:String):void {
			var data:JobData = new JobData();
			data._name = jobName;
			data._description = description;
			data._baseATK = baseATK;
			data._baseDEF = baseDEF;
			data._baseHP = baseHP;
			data._baseST = baseST;
			data._clip = clip;
			
			jobs.push(data);
		}
		
		public static function getJobAt(index:int):JobData {
			return jobs[index];
		}
		
		public static function getNumJobs():uint {
			return jobs.length;
		}

	}
	
}
