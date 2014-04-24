package utils
{
	import flash.text.TextField;

	public class StatusManager
	{
		private static var _instance:StatusManager;
		private static var _creatingSingleton:Boolean = false;
		
		private var _txtField:TextField;
		
		public function StatusManager()
		{
			if (!_creatingSingleton){
				throw new Error("인스턴스를 생성할 수 없습니다.");
			}
		}
		
		public static function GetInstance():StatusManager{
			if (!_instance){
				_creatingSingleton = true;
				_instance = new StatusManager();
				_creatingSingleton = false;
			}
			return _instance;
		}
		
		public function SetStatusTextField(txtField:TextField):void
		{
			_txtField = txtField;
		}
		
		public function SetStatus(status:String):void
		{
			_txtField.text = status;
		}
	}
}