return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = {
				enabled = true,
				preset = {
					header = [[
                $$ $$$$$ $$              
	              $$ $$$$$ $$              
	             .$$ $$$$$ $$.             
	             :$$ $$$$$ $$:             
	             $$$ $$$$$ $$$             
	             $$$ $$$$$ $$$             
	            ,$$$ $$$$$ $$$.            
	           ,$$$$ $$$$$ $$$$.           
	          ,$$$$; $$$$$ :$$$$.          
	         ,$$$$$  $$$$$  $$$$$.         
	       ,$$$$$$'  $$$$$  `$$$$$$.       
	     ,$$$$$$$'   $$$$$   `$$$$$$$.     
	  ,s$$$$$$$'     $$$$$     `$$$$$$$s.  
	$$$$$$$$$'       $$$$$       `$$$$$$$$$
	$$$$$Y'          $$$$$          `Y$$$$$
          ]],
					keys = {
						{ icon = " ", key = "f", desc = "Find File", action = ":lua require('fff').find_files()" },
						{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
						{ icon = " ", key = "g", desc = "Find Text", action = ":lua require('fff').live_grep()" },
						{ icon = " ", key = "e", desc = "File Explorer", action = ":Oil" },
						{ icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
						{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
					},
				},
			},
			quickfile = { enabled = true },
			bigfile = { enabled = true },
			notifier = { enabled = true },
		},
	},
}
