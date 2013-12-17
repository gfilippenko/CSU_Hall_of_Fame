package com.blogspot.jaggerm.cdmeyer
{
	import com.hurlant.crypto.Crypto;
	import com.hurlant.crypto.symmetric.PKCS5;
	import com.hurlant.util.Hex;

	/**
	 * @author Razhnov Igor
	 */
	public class SecurityVolume
	{

		private const KEY:String = "29ec3de50b8fae67293b5f2abb7df3bf6b71d40c76955a910ae8ccfb1733eecb";

		private const NAME:String = "rc4-256-cbc";

		public function SecurityVolume()
		{
		}

		public function applicationCanRun(param1:Vector.<String>, param2:Vector.<String>):Boolean
		{
			var _loc_4:uint = 0;
			var _loc_5:String = null;
			var _loc_3:* = param1.length;
			while (_loc_4 < _loc_3)
			{

				_loc_5 = param1[_loc_4];
				if (this.cipherExistsInSerials(_loc_5, param2))
				{
					return true;
				}
				_loc_5 = null;
				_loc_4 = _loc_4 + 1;
			}
			return false;
		} // end function

		private function cipherExistsInSerials(param1:String, param2:Vector.<String>):Boolean
		{
			var _loc_5:uint = 0;
			var _loc_3:* = param2 ? (param2.length) : (0);
			var _loc_4:* = this.decrypt(param1);
			while (_loc_5 < _loc_3)
			{

				if (param2[_loc_5] == _loc_4)
				{
					_loc_4 = null;
					return true;
				}
				_loc_5 = _loc_5 + 1;
			}
			_loc_4 = null;
			return false;
		} // end function

		private function init():void
		{
			return;
		} // end function

		private function decrypt(param1:String):String
		{
			var _loc_2:* = new PKCS5();
			var _loc_3:* = Hex.toArray(this.KEY);
			var _loc_4:* = Hex.toArray(param1);
			var _loc_5:* = Crypto.getCipher(this.NAME, _loc_3, _loc_2);
			_loc_2.setBlockSize(_loc_5.getBlockSize());
			_loc_5.decrypt(_loc_4);
			_loc_2 = null;
			_loc_3 = null;
			_loc_5 = null;
			return Hex.toString(Hex.fromArray(_loc_4));
		} // end function
	}
}
