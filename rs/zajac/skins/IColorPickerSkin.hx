package rs.zajac.skins;

/**
 * Interface that should be used for ColorPicker skin.
 * @author Aleksandar Bogdanovic
 */
interface IColorPickerSkin implements ISkin {

	/**
	 * Skin class for Palette in color picker.
	 * @return
	 */
	function getPaletteSkinClass(): Class<ISkin>;
	
}