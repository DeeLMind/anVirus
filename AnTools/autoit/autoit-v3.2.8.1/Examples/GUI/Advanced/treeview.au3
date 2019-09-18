#include <GUIConstants.au3>

GUICreate("GUI with more treeviews",340,200,-1,-1,BitOr($WS_MINIMIZEBOX,$WS_MAXIMIZEBOX,$WS_GROUP,$WS_CAPTION,$WS_POPUP,$WS_SYSMENU))

$maintree = GUICtrlCreateTreeView (10,10,120,150)
$aboutitem = GUICtrlCreateTreeViewItem ("About",$maintree)
$generalitem = GUICtrlCreateTreeViewItem ("General",$maintree)
$toolsitem = GUICtrlCreateTreeViewItem ("Tools",$maintree)
$effectitem = GUICtrlCreateTreeViewItem ("Effects",$generalitem)
$styleitem = GUICtrlCreateTreeViewItem ("Styles",$generalitem)
$cmditem = GUICtrlCreateTreeViewItem ("Commandline",$toolsitem)
$miscitem = GUICtrlCreateTreeViewItem ("Misc",$toolsitem)

$descgroup = GUICtrlCreateGroup ("Description",140,105,180,55)
GUICtrlSetState (-1,$GUI_HIDE)

$effectsgroup = GUICtrlCreateGroup ("Effects",140,5,180,95)
GUICtrlSetState (-1,$GUI_HIDE)
$effectstree = GUICtrlCreateTreeView (150,20,160,70,BitOr($TVS_CHECKBOXES,$TVS_DISABLEDRAGDROP),$WS_EX_CLIENTEDGE)
GUICtrlSetState (-1,$GUI_HIDE)
$effect1 = GUICtrlCreateTreeViewItem ("Effect 1",$effectstree)
$effect2 = GUICtrlCreateTreeViewItem ("Effect 2",$effectstree)
$effect3 = GUICtrlCreateTreeViewItem ("Effect 3",$effectstree)
$effect4 = GUICtrlCreateTreeViewItem ("Effect 4",$effectstree)
$effect5 = GUICtrlCreateTreeViewItem ("Effect 5",$effectstree)

$stylesgroup = GUICtrlCreateGroup ("Styles",140,5,180,95)
GUICtrlSetState (-1,$GUI_HIDE)
$stylestree = GUICtrlCreateTreeView (150,20,160,70,BitOr($TVS_CHECKBOXES,$TVS_DISABLEDRAGDROP),$WS_EX_CLIENTEDGE)
GUICtrlSetState (-1,$GUI_HIDE)
$style1 = GUICtrlCreateTreeViewItem ("Style 1",$stylestree)
$style2 = GUICtrlCreateTreeViewItem ("Style 2",$stylestree)
$style3 = GUICtrlCreateTreeViewItem ("Style 3",$stylestree)
$style4 = GUICtrlCreateTreeViewItem ("Style 4",$stylestree)
$style5 = GUICtrlCreateTreeViewItem ("Style 5",$stylestree)

$aboutlabel = GUICtrlCreateLabel ("This is only a treeview demo.",160,80,160,20)

$cancelbutton = GUICtrlCreateButton ("Cancel",130,170,70,20)
GUISetState()

GUIctrlSetState ($effect1,$GUI_CHECKED)
GUIctrlSetState ($effect3,$GUI_CHECKED)
GUIctrlSetState ($style4,$GUI_CHECKED)
GUIctrlSetState ($style5,$GUI_CHECKED)

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = -3 Or $msg = -1 Or $msg = $cancelbutton
			ExitLoop
		Case $msg = $aboutitem
			GUIctrlSetState ($descgroup,$GUI_HIDE)
			GUIctrlSetState ($effectstree,$GUI_HIDE)
			GUIctrlSetState ($effectsgroup,$GUI_HIDE)
			GUIctrlSetState ($stylestree,$GUI_HIDE)
			GUIctrlSetState ($stylesgroup,$GUI_HIDE)
			GUIctrlSetState ($aboutlabel,$GUI_SHOW)
		
		Case $msg = $effectitem
			GUIctrlSetState ($stylestree,$GUI_HIDE)
			GUIctrlSetState ($stylesgroup,$GUI_HIDE)
			GUIctrlSetState ($aboutlabel,$GUI_HIDE)
			GUIctrlSetState ($effectsgroup,$GUI_SHOW)
			GUIctrlSetState ($descgroup,$GUI_SHOW)
			GUICtrlSetState($effectstree,$GUI_SHOW)
			GUICtrlSetBkColor ($effectstree,0xD0F0F0)
			;GUIctrlSetState...($effectstree,$GUI_SHOW)
					
		Case $msg = $styleitem
			GUIctrlSetState ($effectstree,$GUI_HIDE)
			GUIctrlSetState ($effectsgroup,$GUI_HIDE)
			GUIctrlSetState ($aboutlabel,$GUI_HIDE)
			GUIctrlSetState ($stylesgroup,$GUI_SHOW)
			GUIctrlSetState ($descgroup,$GUI_SHOW)
			;GUIctrlSetState.($stylestree,$GUI_SHOW)
			GUICtrlSetState ($stylestree,$GUI_SHOW)
			GUICtrlSetColor ($stylestree,0xD00000)
			GUICtrlSetBkColor ($stylestree,0xD0FFD0)
			
	EndSelect
WEnd

GUIDelete()
Exit