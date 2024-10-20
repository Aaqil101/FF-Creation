#Include Lib\PicSwitch.ahk

g := Gui(,"PicSwitch")

sDisabled := g.AddPicSwitch("Disabled","Switch Disabled")
sOff := g.AddPicSwitch("yp cred","Switch Off")
sOn := g.AddPicSwitch("yp w100","Switch On",1)
sOn.OnEvent("click",Control_Click)
sOn.SPic.OnEvent("click",(*)=>Control_Click(sOn))

m:=Map()
m["Value0DisabledIcon"]:=m["Value1DisabledIcon"]:="*icon226 imageres.dll"
m["Value1Icon"]:="*icon234 imageres.dll"
m["Value0Icon"]:="*icon208 imageres.dll"

sDisabled2 := g.AddPicSwitch("xm Disabled","Switch Disabled",,m)
sOff2 := g.AddPicSwitch("yp","Switch Off",,m)
sOn2 := g.AddPicSwitch("yp w100","Switch On",1)
sOn2.SOpt:=m
sOn2.RefreshStatusIcon

m:=Map()
m["Value0DisabledIcon"]:=m["Value1DisabledIcon"]:="Icon\SW_Value0DisabledIcon.png"
m["Value1Icon"]:="Icon\SW_Value1Icon.png"
m["Value0Icon"]:="Icon\SW_Value0Icon.png"

sDisabled3 := g.AddPicSwitch("xm Disabled","Switch Disabled",,m)
sOff3 := g.AddPicSwitch("yp","Switch Off",,m)
sOn3 := g.AddPicSwitch("yp w100","Switch On",1,m)

m:=Map()
m["SWidth"]:=20
m["SHeight"]:=20
m["Value0DisabledIcon"]:=m["Value1DisabledIcon"]:="Icon\CB_Value0DisabledIcon.png"
m["Value1Icon"]:="Icon\CB_Value1Icon.png"
m["Value0Icon"]:="Icon\CB_Value0Icon.png"

sDisabled2 := g.AddPicSwitch("xm Disabled","Checkbox Disabled",,m)
sOff2 := g.AddPicSwitch("yp","Unchecked",,m)
sOn2 := g.AddPicSwitch("yp w100","Checked",1,m)


; sOn.Value:=0
; sOff.Visible:=False
; sDisabled.Enabled:=True

g.Show

Control_Click(CtrlObj, *) {
	CtrlObj.Text:="Switch " (CtrlObj.Value?"On":"Off")
}