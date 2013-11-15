package com.larrio.dump.doabc.actions
{
	
	/**
	 * DoAction类型常量
	 * @author larryhou
	 * @createTime Dec 24, 2012 10:07:49 PM
	 */
	public class ActionType
	{
		public static const ADD               :uint = 0x0A; // 10
		public static const ADD2              :uint = 0x47; // 71
		public static const AND               :uint = 0x10; // 16
		public static const ASCII_TO_CHAR     :uint = 0x33; // 51
		public static const BIT_AND           :uint = 0x60; // 96
		public static const BIT_LSHIFT        :uint = 0x63; // 99
		public static const BIT_OR            :uint = 0x61; // 97
		public static const BIT_RSHIFT        :uint = 0x64; // 100
		public static const BIT_URSHIFT       :uint = 0x65; // 101
		public static const BIT_XOR           :uint = 0x62; // 98
		public static const CALL              :uint = 0x9E; // 158
		public static const CALL_FUNCTION     :uint = 0x3D; // 61
		public static const CALL_METHOD       :uint = 0x52; // 82
		public static const CAST_OP           :uint = 0x2B; // 43
		public static const CHAR_TO_ASCII     :uint = 0x32; // 50
		public static const CLONE_SPRITE      :uint = 0x24; // 36
		public static const CONSTANT_POOL     :uint = 0x88; // 136
		public static const DECREMENT         :uint = 0x51; // 81
		public static const DEFINE_FUNCTION   :uint = 0x9B; // 155
		public static const DEFINE_FUNCTION2  :uint = 0x8E; // 142
		public static const DEFINE_LOCAL      :uint = 0x3C; // 60
		public static const DEFINE_LOCAL2     :uint = 0x41; // 65
		public static const DELETE            :uint = 0x3A; // 58
		public static const DELETE2           :uint = 0x3B; // 59
		public static const DIVIDE            :uint = 0x0D; // 13
		public static const END_DRAG          :uint = 0x28; // 40
		public static const ENUMERATE         :uint = 0x46; // 70
		public static const ENUMERATE2        :uint = 0x55; // 85
		public static const EQUALS            :uint = 0x0E; // 14
		public static const EQUALS2           :uint = 0x49; // 73
		public static const EXTENDS           :uint = 0x69; // 105
		public static const GET_MEMBER        :uint = 0x4E; // 78
		public static const GET_PROPERTY      :uint = 0x22; // 34
		public static const GET_TIME          :uint = 0x34; // 52
		public static const GET_URL           :uint = 0x83; // 131
		public static const GET_URL2          :uint = 0x9A; // 154
		public static const GET_VARIABLE      :uint = 0x1C; // 28
		public static const GOTO_FRAME        :uint = 0x81; // 129
		public static const GOTO_FRAME2       :uint = 0x9F; // 159
		public static const GOTO_LABEL        :uint = 0x8C; // 140
		public static const GREATER           :uint = 0x67; // 103
		public static const HALT              :uint = 0x5F; // 95
		public static const HAS_LENGTH        :uint = 0x80; // 128
		public static const IF                :uint = 0x9D; // 157
		public static const IMPLEMENTS_OP     :uint = 0x2C; // 44
		public static const INCREMENT         :uint = 0x50; // 80
		public static const INIT_ARRAY        :uint = 0x42; // 66
		public static const INIT_OBJECT       :uint = 0x43; // 67
		public static const INSTANCE_OF       :uint = 0x54; // 84
		public static const JUMP              :uint = 0x99; // 153
		public static const LESS              :uint = 0x0F; // 15
		public static const LESS2             :uint = 0x48; // 72
		public static const MB_ASCII_TO_CHAR  :uint = 0x37; // 55
		public static const MB_CHAR_TO_ASCII  :uint = 0x36; // 54
		public static const MB_STRING_EXTRACT :uint = 0x35; // 53
		public static const MB_STRING_LENGTH  :uint = 0x31; // 49
		public static const MODULO            :uint = 0x3F; // 63
		public static const MULTIPLY          :uint = 0x0C; // 12
		public static const NEW_METHOD        :uint = 0x53; // 83
		public static const NEW_OBJECT        :uint = 0x40; // 64
		public static const NEXT_FRAME        :uint = 0x04; // 4
		public static const NONE              :uint = 0x00; // 0
		public static const NOP               :uint = 0x77; // 119
		public static const NOT               :uint = 0x12; // 18
		public static const OR                :uint = 0x11; // 17
		public static const PLAY              :uint = 0x06; // 6
		public static const POP               :uint = 0x17; // 23
		public static const PREV_FRAME        :uint = 0x05; // 5
		public static const PUSH              :uint = 0x96; // 150
		public static const PUSH_DUPLICATE    :uint = 0x4C; // 76
		public static const RANDOM_NUMBER     :uint = 0x30; // 48
		public static const REMOVE_SPRITE     :uint = 0x25; // 37
		public static const RETURN$           :uint = 0x3E; // 62
		public static const SET_MEMBER        :uint = 0x4F; // 79
		public static const SET_PROPERTY      :uint = 0x23; // 35
		public static const SET_TARGET        :uint = 0x8B; // 139
		public static const SET_TARGET2       :uint = 0x20; // 32
		public static const SET_VARIABLE      :uint = 0x1D; // 29
		public static const STACK_SWAP        :uint = 0x4D; // 77
		public static const START_DRAG        :uint = 0x27; // 39
		public static const STOP              :uint = 0x07; // 7
		public static const STOP_SOUNDS       :uint = 0x09; // 9
		public static const STORE_REGISTER    :uint = 0x87; // 135
		public static const STRICT_EQUALS     :uint = 0x66; // 102
		public static const STRICT_MODE       :uint = 0x89; // 137
		public static const STRING_ADD        :uint = 0x21; // 33
		public static const STRING_EQUALS     :uint = 0x13; // 19
		public static const STRING_EXTRACT    :uint = 0x15; // 21
		public static const STRING_GREATER    :uint = 0x68; // 104
		public static const STRING_LENGTH     :uint = 0x14; // 20
		public static const STRING_LESS       :uint = 0x29; // 41
		public static const SUBTRACT          :uint = 0x0B; // 11
		public static const TARGET_PATH       :uint = 0x45; // 69
		public static const THROW$            :uint = 0x2A; // 42
		public static const TO_INTEGER        :uint = 0x18; // 24
		public static const TO_NUMBER         :uint = 0x4A; // 74
		public static const TO_STRING         :uint = 0x4B; // 75
		public static const TOGGLE_QUALITY    :uint = 0x08; // 8
		public static const TRACE             :uint = 0x26; // 38
		public static const TRY               :uint = 0x8F; // 143
		public static const TYPE_OF           :uint = 0x44; // 68
		public static const WAIT_FOR_FRAME    :uint = 0x8A; // 138
		public static const WAIT_FOR_FRAME2   :uint = 0x8D; // 141
		public static const WITH              :uint = 0x94; // 148
	}
}