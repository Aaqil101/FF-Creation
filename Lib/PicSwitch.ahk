;================================================================================
; PicSwitch - Switch, Checkbox controls with picture
; tranht17
; 2023/12/12
;================================================================================
Class PicSwitch Extends Gui.Text {
    Static __New() {
        Gui.Prototype.AddPicSwitch:=this.AddPicSwitch
    }
	Static AddPicSwitch(Options:="", sText:="", iValue:=0, SOptions:="") {
		wPic:=hPic:=36
		If SOptions && SOptions.Has("SWidth")
			wPic:=SOptions["SWidth"]
		If SOptions && SOptions.Has("SHeight")
			hPic:=SOptions["SHeight"]
		
		ctlTxt:=this.AddText("BackgroundTrans 0x200 " Options,sText)
        ctlPic:=this.AddPic("BackgroundTrans w" wPic " h" hPic " yp")
		
		ctlTxt.GetPos(&X, &Y)
		ctlPic.Move(X, Y)
		ctlTxt.Move(X+wPic+3, Y,,hPic)
		
		ctlEnabled:=ctlTxt.Enabled
		ctlVisible:=ctlTxt.Visible
		ctlPic.Enabled:=ctlEnabled
		ctlPic.Visible:=ctlVisible
		
		
        ctlTxt.base:=PicSwitch.Prototype
		ctlTxt.SPic:=ctlPic
		ctlTxt._Value:=iValue
		ctlTxt._Enabled:=ctlEnabled
		ctlTxt._Visible:=ctlVisible

		ctlTxt.OnEvent("click",ObjBindMethod(ctlTxt,"_ClickChangeValue"))
		ctlPic.OnEvent("click",ObjBindMethod(ctlTxt,"_ClickChangeValue"))
		
		ctlTxt.SOpt:=Map()
		If SOptions
			ctlTxt.SOpt:=SOptions
		
		If !ctlTxt.SOpt.Has("Value1Icon")
			ctlTxt.SOpt["Value1Icon"]:="*icon102 imageres.dll"
		If !ctlTxt.SOpt.Has("Value0Icon")
			ctlTxt.SOpt["Value0Icon"]:="*icon101 imageres.dll"
		If !ctlTxt.SOpt.Has("Value0DisabledIcon")
			ctlTxt.SOpt["Value0DisabledIcon"]:="*icon100 imageres.dll"
		If !ctlTxt.SOpt.Has("Value1DisabledIcon")
			ctlTxt.SOpt["Value1DisabledIcon"]:="*icon100 imageres.dll"
		If !ctlTxt.SOpt.Has("SWidth")
			ctlTxt.SOpt["SWidth"]:=wPic
		If !ctlTxt.SOpt.Has("SHeight")
			ctlTxt.SOpt["SHeight"]:=hPic
		ctlTxt.RefreshStatusIcon
        return ctlTxt
    }
	Type => "PicSwitch"
	Value {
        get => this._Value
        set {
			if (this._Value!=value) {
				this._Value:=value
				this.RefreshStatusIcon
			}
			Return value
		}
    }
	Enabled	{
		get => this._Enabled
        set {
			if (this._Enabled!=value) {
				super.Enabled:=value
				this.SPic.Enabled:=value
				this._Enabled:=value
				this.RefreshStatusIcon
			}
			Return value
		}
	}
	Visible	{
		get => this._Visible
        set {
			if (this._Visible!=value) {
				super.Visible:=value
				this.SPic.Visible:=value
				this._Visible:=value
			}
			Return value
		}
	}
	Move(X?, Y?, W?, H?) {
		this.SPic.Move(X?, Y?,, H?)
		this.SPic.GetPos(,,&wSPic)
		super.Move(IsSet(X)?X+wSPic+3:(X?), Y?, W?, H?)
	}
	_ClickChangeValue(*) {
		this._Value:=!this._Value
		this.RefreshStatusIcon
	}
	RefreshStatusIcon(*) {
		this.SPic.GetPos(&sX,, &sW, &sH)
		If sW!=this.SOpt["SWidth"] {
			this.SPic.Move(,, this.SOpt["SWidth"])
			super.Move(sX+this.SOpt["SWidth"]+3)
		}
		If sH!=this.SOpt["SHeight"] {
			this.Move(,,, this.SOpt["SHeight"])
		}
		t:=this._Value (this._Enabled?"":"Disabled")
		this.SPic.Value:=this.SOpt["Value" t "Icon"]
   }
}
