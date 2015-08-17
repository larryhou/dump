package com.larrio.dump.utils
{
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 
	 * @author larryhou
	 * @createTime Aug 17, 2015 4:48:07 PM
	 */
	public function cloneObject(target:Object):*
	{
		if (target == null) return null;
		
		var name:String = getQualifiedClassName(target);
		registerClassAlias("alias." + name, getDefinitionByName(name) as Class);
		
		var bytes:ByteArray = new ByteArray();
		bytes.writeObject(target);
		bytes.position = 0;
		
		return bytes.readObject();
	}
}