unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  FMX.StdCtrls, FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.Jni.JavaTypes,
  Androidapi.JNI.Speech;

type
    // ��ʼ������
  TTTSIniL = class(TJavaLocal, JTextToSpeech_OnInitListener)
  public
    // ��д��ʼ�������¼�
    procedure onInit(status: Integer); cdecl;
  end;

  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    mTextToSpeech: JTextToSpeech;  //��׿�������ϳ�
    vTTSIniL: TTTSIniL;//ǰ�����Ƕ���ļ�����
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
    // �����ʶ�����
    supported := Form1.mTextToSpeech.setLanguage(TJLocale.JavaClass.CHINA);
    if ((supported <> TJTextToSpeech.JavaClass.LANG_AVAILABLE) and
      (supported <> TJTextToSpeech.JavaClass.LANG_COUNTRY_AVAILABLE)) then
    begin
      showmessage('��֧�ֵ�ǰ���ԣ�');
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
  // ����ʱ����ʼ����������
  vTTSIniL := TTTSIniL.Create;//��������
  mTextToSpeech := TJTextToSpeech.JavaClass.init(TAndroidHelper.context,vTTSIniL);//��ʼ�������ϳ�
end;

end.
