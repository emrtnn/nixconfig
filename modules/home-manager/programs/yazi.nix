{ config-files, ... }:
{
	programs.yazi = {
		enable = true;
		initLua = config-files.yazi.initLua;
		settings = {
			mgr = {
				ratio = [ 2 4 4 ]  ;
				sort_by = "natural";
				sort_translit = true;
				sort_dir_first = true;
				show_symlink = true;
			};
			preview = {
				wrap = "no";
				tab_size = 1;
				max_width = 1250;
				image_filter = "triangle";
				image_quality = 90;
			};
		};
		keymap = {
			mgr.prepend_keymap = [
				{ run = "plugin copy-file-contents"; on = "<A-y>"; desc = "Copy contents of the file"; }
			];
		};
	};
}
