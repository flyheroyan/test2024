unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.Helpers.Android,

type
    // 初始化监听
  TTTSIniL = class(TJavaLocal, JTextToSpeech_OnInitListener)
  public
    // 重写初始化监听事件
    procedure onInit(status: Integer); cdecl;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button3: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    mTextToSpeech: JTextToSpeech;  //安卓的语音合成
    vTTSIniL: TTTSIniL;//前面我们定义的监听类
  end;


{ TScanBroadcastReceiver }

var
  Form1: TForm1;

implementation

{$R *.fmx}
procedure TTTSIniL.onInit(status: Integer);
var
  supported: Integer;
begin
  if (status = TJTextToSpeech.JavaClass.SUCCESS) then
  begin
    // 设置朗读语言
    supported := Form1.mTextToSpeech.setLanguage(TJLocale.JavaClass.CHINA);
    if ((supported <> TJTextToSpeech.JavaClass.LANG_AVAILABLE) and
      (supported <> TJTextToSpeech.JavaClass.LANG_COUNTRY_AVAILABLE)) then
    begin
      showmessage('不支持当前语言！');
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  mTextToSpeech.speak(StringToJString(Memo1.Text),TJTextToSpeech.JavaClass.QUEUE_FLUSH, nil);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  mTextToSpeech.stop;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(mTextToSpeech) then
    mTextToSpeech.shutdown;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  
  vTTSIniL := TTTSIniL.Create;  mTextToSpeech := TJTextToSpeech.JavaClass.init(TAndroidHelper.context,vTTSIniL);//初始化语音合成
end;

end.
