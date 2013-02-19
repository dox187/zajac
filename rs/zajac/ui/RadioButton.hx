package rs.zajac.ui;
import rs.zajac.core.FWCore;
import rs.zajac.managers.RadioGroup;
import rs.zajac.skins.RadioButtonSkin;
import rs.zajac.util.TextFieldUtil;
#if (android || ios)
import nme.events.TouchEvent;
#end
import nme.events.Event;
import nme.events.MouseEvent;
import nme.text.TextField;
import nme.text.TextFieldAutoSize;
import nme.text.TextFormatAlign;

/**
 * ...
 * @author Ilic S Stojan
 */

class RadioButton extends StyledComponent{

	inline public static var UP:		String = 'up';
	inline public static var OVER:		String = 'over';
	inline public static var DOWN:		String = 'down';
	inline public static var SELECTED:	String = 'selected';
	
	@style public var color: Int = 0;					//text color
	@style public var backgroundColor: Int = 0xffffff;	//backgroundColor
	@style public var iconColor: Int = 0x666666;		//color of X of ok icon in the middle of the button box
	@style public var roundness: Int = -1;				//roundness = -1 - icon is circle, if roundness is >= 0 icon is rect with selected roundness
	@style public var borderColor: Int = -1;
	
	@style public var buttonSize(get_buttonSize, default):Float;//: Float = 20;		//size of checked icon in pixels
	private function get_buttonSize():Float {
		return Math.min(_getStyleProperty("buttonSize", FWCore.getHeightUnit()), Height);
	}
	
	private var _tLabel:TextField;
	private function get_tLabel():TextField {
		return _tLabel;
	}
	public var labelField(get_tLabel, null):TextField;
	
	private var _isOver:Bool;
	
	private var _label:String;
	private function get_label():String {
		return _label;
	}
	private function set_label(value:String):String {
		if (value == null) _label = ""
			else _label = value;
		_tLabel.text = _label;
		invalidSkin();
		return _label;
	}
	public var label(get_label, set_label):String;
	
	private var _selected:Bool;
	private function get_selected():Bool {
		return _selected;
	}
	private function set_selected(value:Bool):Bool {
		var c_changed:Bool = false;
		
		if (_selected != value) c_changed = true;
		
		_selected = value;
		
		if (_selected) state = SELECTED
			else {
				if (_isOver) state = OVER
					else state = UP;
			}
		
		if (c_changed) dispatchEvent(new Event(Event.CHANGE));
		return _selected;
	}
	public var selected(get_selected, set_selected):Bool;
	
	
	//public var groupName:String;
	private var _groupName:String;
	private function get_groupName():String {
		return _groupName;
	}
	private function set_groupName(value:String):String {
		//TODO: remove button from radiobutton group when button is destroyed
		RadioGroup.gi().addButton(this, value);
		return _groupName = value;
	}
	public var groupName(get_groupName, set_groupName):String;
	
	public function new() {
		super();
		defaultWidth = FWCore.getHeightUnit() * 5;
		defaultHeight = FWCore.getHeightUnit();
		state = UP;
	}
	
	override private function initialize(): Void {
		_tLabel = new TextField();
		TextFieldUtil.fillFieldFromObject(_tLabel, { align:TextFormatAlign.LEFT, multiline:false, autoSize:TextFieldAutoSize.LEFT, selectable:false, mouseEnabled:false, size: FWCore.getFontSize() } );
		addChild(_tLabel);
		
		#if (android || ios)
		addEventListener(TouchEvent.TOUCH_BEGIN,onTouchBegin);
		addEventListener(TouchEvent.TOUCH_END, 	onTouchEnd);
		addEventListener(TouchEvent.TOUCH_OVER,	onTouchOver);
		addEventListener(TouchEvent.TOUCH_OUT,	onTouchOut);
		#else
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, 	onMouseUp);
		addEventListener(MouseEvent.ROLL_OVER, 	onMouseOver);
		addEventListener(MouseEvent.ROLL_OUT, 	onMouseOut);
		buttonMode = true;
		#end
		addEventListener(MouseEvent.CLICK, 		onClick);
		
		skinClass = RadioButtonSkin;
	}
	
	#if (android || ios)
	
	private function onTouchBegin(e: TouchEvent): Void {
		if (!enabled) return;
		state = DOWN;
	}
	
	private function onTouchEnd(e: TouchEvent): Void {
		if (!enabled) return;
		state = UP;
	}
	
	private function onTouchOver(e: TouchEvent): Void {
		if (!enabled) return;
		state = DOWN;
	}
	
	private function onTouchOut(e: TouchEvent): Void {
		if (!enabled) return;
		state = UP;
	}
	
	#else
	private function onMouseDown(e:MouseEvent):Void {
		if (!_selected) state = DOWN;
		//selected = true;
	}
	
	private function onMouseUp(e:MouseEvent):Void {
		if (_selected) return;
		if (_isOver) state = OVER
			else state = UP;
	}
	
	private function onMouseOver(e:MouseEvent):Void {
		_isOver = true;
		if (!_selected) state = OVER;
	}
	
	private function onMouseOut(e:MouseEvent):Void {
		_isOver = false;
		if (!_selected) state = UP;
	}
	#end
	
	private function onClick(e:MouseEvent):Void {
		selected = true;
	}
	
	
}