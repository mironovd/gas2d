unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, Spin, GraphUtil, Buttons, Math, types;

type

  { TForm1 }
  dir = array [1..2] of integer;

  TForm1 = class(TForm)
    BFwd: TButton;
    BStop: TButton;
    BSkip100: TButton;
    Clear: TButton;
    Ckecker: TButton;
    CFast: TCheckBox;
    CenterPr: TEdit;
    ESkip: TEdit;
    Label6: TLabel;
    Label8: TLabel;
    PistonIdleSteps: TLabel;
    LeftDnPr: TFloatSpinEdit;
    LeftUpPr: TFloatSpinEdit;
    RightDnPr: TFloatSpinEdit;
    RightUpPr: TFloatSpinEdit;
    Step4: TButton;
    StepCount: TLabel;
    UpPr: TFloatSpinEdit;
    LeftPr: TFloatSpinEdit;
    RightPr: TFloatSpinEdit;
    DownPr: TFloatSpinEdit;
    Label4: TLabel;
    LPressure: TLabel;
    Rand: TButton;
    RR:TEdit;
    Label3: TLabel;
    LDensity: TLabel;
    Label5: TLabel;
    LEnergy: TLabel;
    Label7: TLabel;
    LTemp: TLabel;
    Step3: TButton;
    Step2: TButton;
    Step1: TButton;
    Pano: TImage;
    Label1: TLabel;
    Label2: TLabel;
    NE: TSpinEdit;
    ME: TSpinEdit;
    Timer: TTimer;

    procedure BFwdClick(Sender: TObject);
    procedure BSkip100Click(Sender: TObject);
    procedure BStopClick(Sender: TObject);
    procedure CFastChange(Sender: TObject);
    procedure CkeckerClick(Sender: TObject);
    procedure ClearClick(Sender: TObject);
    procedure DownPrChange(Sender: TObject);
    procedure CenterPrChange(Sender: TObject);
    procedure LeftPrChange(Sender: TObject);
    procedure RandClick(Sender: TObject);
    procedure RightPrChange(Sender: TObject);

    procedure Step2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure drawgrid(SCanvas: TCanvas; N: Integer; M: Integer);
    procedure MEChange(Sender: TObject);
    procedure NEChange(Sender: TObject);
    procedure PanoClick(Sender: TObject);
    procedure PanoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PanoResize(Sender: TObject);
    procedure redimension();
    function gendir(): dir;
    procedure reprob();
    procedure Step1Click(Sender: TObject);
    procedure Step3Click(Sender: TObject);
    procedure Step4Click(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure UpPrChange(Sender: TObject);
  private
    { private declarations }

  public
    { public declarations }
  end;

var
  Form1: TForm1;
  points: array [0..101] of array [0..101] of boolean;
  xpoints: array [0..101] of array [0..101] of boolean;
  bpoints: array [0..101] of array [0..101] of boolean;
  dirs: array [0..101] of array [0..101] of dir;
  adirs: array [0..101] of array [0..101] of dir;
  qdirs: array [0..101] of array [0..101] of dir;
  qqdirs: array [0..101] of array [0..101] of dir;
  probs: array [-1..1] of array [-1..1] of real;
  sumprobs:array [-1..1] of array [-1..1] of real;
  state: integer;
  SCount: integer;
  pistonX: integer;
  pistonstoppedtime: integer;
  draw : boolean;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.reprob();
var i,j:integer;
  s:real;
begin
    probs[-1,0]:=LeftPr.Value;
    probs[1,0]:=RightPr.Value;
    probs[0,1]:=DownPr.Value;
    probs[0,-1]:=UpPr.Value;

    s:=-probs[0,0];
     for i:=-1 to 1 do begin
         for j:=-1 to 1 do begin
           s+=probs[i,j];
         end;
     end;
    probs[0,0]:=1-s;
    CenterPr.Text:=floattostr(round(probs[0,0]*100)/100);

    LeftPr.MaxValue:=LeftPr.Value+probs[0,0];
    UpPr.MaxValue:=UpPr.Value+probs[0,0];
    DownPr.MaxValue:=DownPr.Value+probs[0,0];
    RightPr.MaxValue:=RightPr.Value+probs[0,0];

    s:=0;
     for i:=-1 to 1 do begin
         for j:=-1 to 1 do begin
           s+=probs[i,j];
           sumprobs[i,j]:=s;
         end;
     end;

end;

procedure TForm1.Step1Click(Sender: TObject);
var i,j,M,N:integer;
  p,q,r,s:TPoint;
  pz:array [1..3] of TPoint;
begin
  M:=ME.Value; N:=NE.Value;
  if draw then Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
  if draw then  Pano.Canvas.Pen.Color:=$FF0000;
  for i:=1 to M do begin
    for j:=1 to N do begin
      if points[i,j] then begin
       dirs[i,j]:=gendir();
       p.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M)) ;
       p.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N)) ;
       q.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+dirs[i,j,1]*round(Pano.Width/(2*M)) ;
       q.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+dirs[i,j,2]*round(Pano.Height/(2*N)) ;
       r.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+dirs[i,j,2]*round(Pano.Width/(2*M)) ;
       r.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+dirs[i,j,1]*round(Pano.Height/(2*N)) ;
       s.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))-dirs[i,j,2]*round(Pano.Width/(2*M)) ;
       s.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))-dirs[i,j,1]*round(Pano.Height/(2*N)) ;
       pz[1]:=q;pz[2]:=r;pz[3]:=s;
       if draw then Pano.Canvas.Brush.Color:=$FF0000;
       if draw then Pano.Canvas.Polygon(pz);
//       Pano.Canvas.Pen.Color:=$FF0000;
//       GraphUtil.DrawArrow(Pano.Canvas,p,q);
      end;
    end;
  end;
  if draw then  Pano.Canvas.Pen.Color:=$000000;
end;

procedure TForm1.Step3Click(Sender: TObject);
var i,j,M,N,MM:integer;
  p,q:TPoint;
  d: dir;
begin
  M:=ME.Value;MM:=min(ME.Value,pistonX); N:=NE.Value;


  for i:=1 to MM do begin
    for j:=1 to N do begin
      if points[i,j] then begin

       d:=adirs[i,j];

        if  ((adirs[i+d[1],j+d[2],1]=-d[1]) and (adirs[i+d[1],j+d[2],2]=-d[2])) then continue;

       points[i,j]:=false;
       points[i+d[1],j+d[2]]:=true;
      end;
    end;
  end;
        for i:=0 to 101 do begin
           for j:=0 to 101 do begin
             dirs[i,j,1]:=0; dirs[i,j,2]:=0;
           end;
        end;

  if draw then  Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
  SCount:=SCount+1;
  StepCount.Caption:=inttostr(SCount);
end;

procedure TForm1.Step4Click(Sender: TObject);
var i,j,M,MM,N,k,l,v,s:integer;
  p,q,t,u:TPoint;
  pz:array [1..3] of TPoint;
  moved: boolean;
  jj:boolean;
begin
  M:=ME.Value;MM:=min(ME.Value,pistonX); N:=NE.Value;
  if draw then  Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
  bpoints:=points;
  moved:=true;

  for i:=1 to 101 do for j:=1 to 101 do begin qdirs[i,j,1]:=0; qdirs[i,j,2]:=0; end;
  for i:=1 to 101 do for j:=1 to 101 do begin qqdirs[i,j,1]:=0; qqdirs[i,j,2]:=0; end;

  for i:=1 to N do begin
    if not bpoints[MM,i] then
           continue
    else
        jj:=false;
        for j:=MM downto 1 do begin
            if not bpoints[j,i] then begin
               jj:=true;
               for k:=j to MM-1 do begin
                   bpoints[k,i]:=true;
                   bpoints[k+1,i]:=false;
                   qdirs[k,i,1]:=-1;
                   qqdirs[k+1,i,1]:=-1;
               end;
               break;
            end
        end;
        if jj then continue
        else begin

             moved:=false;
        end;
    end;

    if moved then begin
             pistonstoppedtime:=0;
             pistonX:=pistonX-1;
             points:=bpoints;
             if draw then begin
                Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
                Pano.Canvas.Brush.Color:=$00FF00;
                Pano.Canvas.Rectangle(round(Pano.Width*(pistonX)/M),0,round(Pano.Width*(pistonX+1)/M),Pano.Height);
                for i:=1 to M do
                    for j:=1 to N do
                        if points[i,j] then begin
                           if draw then  Pano.Canvas.Brush.Color:=$00FF00;
                           p.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M)) ;
                           p.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N)) ;
                           q.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+qdirs[i,j,1]*round(Pano.Width/(2*M)) ;
                           q.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+qdirs[i,j,2]*round(Pano.Height/(2*N)) ;
                           t.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+qdirs[i,j,2]*round(Pano.Width/(2*M)) ;
                           t.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+qdirs[i,j,1]*round(Pano.Height/(2*N)) ;
                           u.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))-qdirs[i,j,2]*round(Pano.Width/(2*M)) ;
                           u.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))-qdirs[i,j,1]*round(Pano.Height/(2*N)) ;
                           pz[1]:=q;pz[2]:=t;pz[3]:=u;
                           if draw then  Pano.Canvas.Polygon(pz);
                        end;
             end
    end
    else begin
         if draw then begin
                Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
                Pano.Canvas.Brush.Color:=$0000FF;
                Pano.Canvas.Rectangle(round(Pano.Width*(pistonX)/M),0,round(Pano.Width*(pistonX+1)/M),Pano.Height);
                for i:=1 to M do
                    for j:=1 to N do
                        if points[i,j] then begin
                           if draw then  Pano.Canvas.Brush.Color:=$0000FF;
                           p.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M)) ;
                           p.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N)) ;
                           q.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+qqdirs[i,j,1]*round(Pano.Width/(2*M)) ;
                           q.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+qqdirs[i,j,2]*round(Pano.Height/(2*N)) ;
                           t.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+qqdirs[i,j,2]*round(Pano.Width/(2*M)) ;
                           t.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+qqdirs[i,j,1]*round(Pano.Height/(2*N)) ;
                           u.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))-qqdirs[i,j,2]*round(Pano.Width/(2*M)) ;
                           u.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))-qqdirs[i,j,1]*round(Pano.Height/(2*N)) ;
                           pz[1]:=q;pz[2]:=t;pz[3]:=u;
                           if draw then  Pano.Canvas.Polygon(pz);

             end
         end;
         pistonstoppedtime:=pistonstoppedtime+1;
    end;
end;

procedure TForm1.TimerTimer(Sender: TObject);
begin
    state:=state+1;
  case state of
       1: Step1Click(Form1);
       2: Step2Click(Form1);
       3: Step3Click(Form1);
       else state:=0;
  end;
end;

procedure TForm1.UpPrChange(Sender: TObject);
begin
  reprob();
end;

function TForm1.gendir() :dir;
var r : real;
  i,j:integer;
  dirr: dir;
begin
     r:=random;
     for i:=-1 to 1 do begin
         for j:=-1 to 1 do begin
             if sumprobs[i,j]>=r then
                break;
         end;
         if sumprobs[i,j]>=r then
                break;
     end;
     dirr[1]:=i; dirr[2]:=j;
     gendir:=dirr;
end;

procedure TForm1.redimension();
var i,j:integer;
begin
//    SetLength(points,NE.Value+1,ME.Value+1);
      for i:=0 to 101 do begin
           for j:=0 to 101 do begin
  //            points[i,j]:=false;
              dirs[i,j,1]:=0; dirs[i,j,2]:=0;
           end;
        end;
      pistonX:=ME.Value-3;
      pistonstoppedtime:=0;
end;

procedure TForm1.FormCreate(Sender: TObject);
var i,j:integer;
begin
//        Pano.Height:=Form1.Height-200;
          Pano.Picture.Bitmap.SetSize(2960,1980);
          ME.Value:=round(Pano.Width/30);
          NE.Value:=round(Pano.Height/30);
          redimension;
        draw:=true;
        Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
        for i:=0 to 101 do begin
           for j:=0 to 101 do begin
              points[i,j]:=false;
              dirs[i,j,1]:=0; dirs[i,j,2]:=0;
           end;
        end;
        probs[-1,-1]:=0; probs[-1,1]:=0; probs[1,-1]:=0; probs[1,1]:=0;
//        probs[1,0]:=0.2; probs[0,1]:=0.2; probs[-1,0]:=0.2; probs[0,-1]:=0.2;
//        probs[0,0]:=0.2;
        reprob;
        SCount:=0;
        StepCount.Caption:=inttostr(SCount);
        PistonIdleSteps.Caption:=inttostr(pistonstoppedtime);
end;

procedure TForm1.Step2Click(Sender: TObject);
var i,j,M,MM,N,k,l,v,s:integer;
  p,q,t,u:TPoint;
  pz:array [1..3] of TPoint;
  d: dir;
  vv: array [1..9] of dir;
  count,countmov:integer;
  r: real;
begin
//Memo1.Text:='';
  M:=ME.Value;MM:=min(ME.Value,pistonX); N:=NE.Value;
  if draw then  Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
  count:=0; countmov:=0;
         for i:=0 to 101 do begin
           for j:=0 to 101 do begin
             adirs[i,j,1]:=0; adirs[i,j,2]:=0;
 //            adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
               xpoints[i,j]:=points[i,j];
           end;
        end;
  for i:=1 to MM do begin
    for j:=1 to N do begin
          adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
     end;
   end;
  for i:=1 to M do begin
    for j:=1 to N do begin
      if points[i,j] then begin
       if draw then  Pano.Canvas.Brush.Color:=$FF0000;
       p.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M)) ;
       p.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N)) ;
       q.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+dirs[i,j,1]*round(Pano.Width/(2*M)) ;
       q.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+dirs[i,j,2]*round(Pano.Height/(2*N)) ;
       t.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))+dirs[i,j,2]*round(Pano.Width/(2*M)) ;
       t.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))+dirs[i,j,1]*round(Pano.Height/(2*N)) ;
       u.X:=round(Pano.Width*(i-1)/M)+round(Pano.Width/(2*M))-dirs[i,j,2]*round(Pano.Width/(2*M)) ;
       u.Y:=round(Pano.Height*(j-1)/N)+round(Pano.Height/(2*N))-dirs[i,j,1]*round(Pano.Height/(2*N)) ;
       pz[1]:=q;pz[2]:=t;pz[3]:=u;
       if draw then  Pano.Canvas.Polygon(pz);
//       GraphUtil.DrawArrow(Pano.Canvas,p,q);
       count:=count+1;
       d:=dirs[i,j];


        if ((adirs[i,j,1]=0) and (adirs[i,j,2]=0)) and xpoints[i,j] then begin

           if draw then  Pano.Canvas.Brush.Color:=$FF0000;
//          GraphUtil.DrawArrow(Pano.Canvas,p,q);
            Pano.Canvas.Polygon(pz);
          continue;

         end
        else if not xpoints[i,j] then begin
          if not(( adirs[i,j,1]=0) and ( adirs[i,j,2]=0)) then begin

                 if draw then  Pano.Canvas.Brush.Color:=$0000FF;
                 countmov:=countmov+1;
          end
          else begin
             if draw then  Pano.Canvas.Brush.Color:=$FF0000;
          end;
//          GraphUtil.DrawArrow(Pano.Canvas,p,q);
            if draw then  Pano.Canvas.Polygon(pz);
          continue;
        end

        else begin
//       if (adirs[i,j,1]=0) and (adirs[i,j,2]=0) then continue;
      adirs[i,j,1]:=0; adirs[i,j,2]:=0;
       if i+d[1]>MM then continue;
       if j+d[2]>N then continue;
       if i+d[1]<=0 then continue;
       if j+d[2]<=0 then continue;

       if points[i+d[1],j+d[2]] then begin
        if not ((dirs[i+d[1],j+d[2],1]=-d[1]) and (dirs[i+d[1],j+d[2],2]=-d[2])) then continue
        else   begin
          adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
        end;
       end;

       v:=0;
       for k:=1 to 9 do begin
          vv[k,1]:=0; vv[k,2]:=0;
       end;
//       vv[1,1]:=-d[1];vv[1,2]:=-d[2];
       if not points[i+d[1],j+d[2]] then begin
        for k:=-1 to 1 do begin
          for l:=-1 to 1 do begin
              if not ((i+d[1]+k>MM)or (i+d[1]+k<=0)or (j+d[2]+l>N)
                     or (j+d[2]+l<=0)) then begin
                        if points[i+d[1]+k,j+d[2]+l] then begin
                           if (dirs[i+d[1]+k,j+d[2]+l,1]=-k) and (dirs[i+d[1]+k,j+d[2]+l,2]=-l) then begin
                              v:=v+1;
                              vv[v,1]:=k; vv[v,2]:=l;

                           end;
                        end;
              end;
          end;
        end;
       end;

       if v>1 then begin
       s:=trunc(random()*v)+1;
//       Memo1.Text:=Memo1.Text+inttostr(s)+'of'+inttostr(v)+'!';
       for k:=1 to v do begin
 //        if not k=s then begin
          adirs[i+d[1]+vv[k,1],j+d[2]+vv[k,2],1]:=0;
          adirs[i+d[1]+vv[k,1],j+d[2]+vv[k,2],2]:=0;
          xpoints[i+d[1]+vv[k,1],j+d[2]+vv[k,2]]:=false;
 //        end;
       end;
         adirs[i+d[1]+vv[s,1],j+d[2]+vv[s,2],1]:=dirs[i+d[1]+vv[s,1],j+d[2]+vv[s,2],1];
         adirs[i+d[1]+vv[s,1],j+d[2]+vv[s,2],2]:=dirs[i+d[1]+vv[s,1],j+d[2]+vv[s,2],2];
         if(not vv[s,1]=-d[1]) or (not vv[s,2]=-d[2]) then countmov:=countmov+1;

       end
       else begin
           adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
       end;

       if (adirs[i,j,1]=0) and (adirs[i,j,2]=0) then begin
          if draw then  Pano.Canvas.Brush.Color:=$FF0000;
//                 GraphUtil.DrawArrow(Pano.Canvas,p,q);
          if draw then  Pano.Canvas.Polygon(pz);
          continue;

       end;
       adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
       countmov:=countmov+1;
       if draw then  Pano.Canvas.Brush.Color:=$0000FF;
//       GraphUtil.DrawArrow(Pano.Canvas,p,q);
       if draw then  Pano.Canvas.Polygon(pz);

        end;
      end;
    end;
  end;
  countmov:=0;
  for i:=1 to ME.Value do begin
     for j:=1 to NE.Value do begin
         if points[i,j] then
                if not ((adirs[i,j,1]=0) and (adirs[i,j,2] =0)) then
                       countmov:=countmov+1;
     end;
  end;
  if draw then  Pano.Canvas.Pen.Color:=$000000;
  if draw then  LDensity.Caption:=floattostr(round(count/(N*M)*100)/100);
  if draw then  LEnergy.Caption:=inttostr(countmov);
  if draw then  LTemp.Caption:=floattostr(round(countmov/count*100)/100);
  if draw then  LPressure.Caption:=floattostr(round(countmov/(N*M)*100)/100);
end;

procedure TForm1.RandClick(Sender: TObject);
var i,j:integer;
begin
     redimension;
     for i:=1 to Min(ME.Value,pistonX) do begin
       for j:=1 to NE.Value do begin
         points[i,j]:= random()<=strtofloat(RR.Text);
       end;
     end;
     Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
     SCount:=0;
    StepCount.Caption:=inttostr(SCount);
    PistonIdleSteps.Caption:=inttostr(pistonstoppedtime);
    LDensity.Caption:='';
    LEnergy.Caption:='';
    LTemp.Caption:='';
    LPressure.Caption:='';

end;

procedure TForm1.RightPrChange(Sender: TObject);
begin
  reprob();
end;

procedure TForm1.BFwdClick(Sender: TObject);
begin
   state:=0;
   Timer.Enabled:=true;
end;

procedure TForm1.BSkip100Click(Sender: TObject);
var o:integer;
begin
     draw:=false;
     for o:=1 to strtoint(ESkip.Text)-1 do begin
              Step1Click(Form1);
              Step2Click(Form1);
              Step3Click(Form1);
       end;
     draw:=true;
                   Step1Click(Form1);
              Step2Click(Form1);
              Step3Click(Form1);

end;

procedure TForm1.BStopClick(Sender: TObject);
begin
  state:=0;
  Timer.Enabled:=false;
end;

procedure TForm1.CFastChange(Sender: TObject);
begin
  if CFast.State=cbChecked then Timer.Interval:=8 else Timer.Interval:=125;
end;

procedure TForm1.CkeckerClick(Sender: TObject);
var t,v:boolean;
  i,j:integer;
begin
    t:=true; v:=true;
    redimension;
    for i:=1 to NE.Value do begin
      t:=v; v:=not v;
       for j:=1 to Min(ME.Value,pistonX) do begin
           points[j,i]:=t;
           t:=not t;
       end;
    end;
    Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
    SCount:=0;
    StepCount.Caption:=inttostr(SCount);
    PistonIdleSteps.Caption:=inttostr(pistonstoppedtime);
    LDensity.Caption:='';
    LEnergy.Caption:='';
    LTemp.Caption:='';
    LPressure.Caption:='';

end;

procedure TForm1.ClearClick(Sender: TObject);
var i,j:integer;
begin
    for i:=0 to 101 do begin
       for j:=0 to 101 do begin
           points[i,j]:=false;
       end;
    end;
    redimension;
    Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
    SCount:=0;
    StepCount.Caption:=inttostr(SCount);
    PistonIdleSteps.Caption:=inttostr(pistonstoppedtime);
    LDensity.Caption:='';
    LEnergy.Caption:='';
    LTemp.Caption:='';
    LPressure.Caption:='';
end;

procedure TForm1.DownPrChange(Sender: TObject);
begin
  reprob();
end;

procedure TForm1.CenterPrChange(Sender: TObject);
begin

end;

procedure TForm1.LeftPrChange(Sender: TObject);
begin
  reprob();
end;




procedure TForm1.FormResize(Sender: TObject);
//var u:TRect;
begin
//    Pano.Height:=Form1.Height-200;
    Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
//    u.Top:=0;u.Left:=0;u.Bottom:=Pano.Height; u.Top:=Pano.Width;
//    Pano.Picture.Bitmap.SetSize(Pano.Width,Pano.Height);
end;

procedure TForm1.drawgrid(SCanvas: TCanvas;N: Integer; M: Integer);
var i,j:integer;
begin
    SCanvas.Brush.Color:=$FFFFFF;
    SCanvas.FillRect(0,0,Pano.Width,Pano.Height);
    SCanvas.Brush.Color:=$000000;
    SCanvas.Pen.Color:=$000000;
    for i:=1 to N-1 do begin
       SCanvas.Line(0,round((Pano.Height / N)*i),Pano.Width,round((Pano.Height / N)*i));
    end;
    for i:=1 to M-1 do begin
       SCanvas.Line(round((Pano.Width/M)*i),0,round((Pano.Width/M)*i),Pano.Height);
    end;
    for i:=1 to M do begin
       for j:=1 to N do begin
          if points[i,j] then begin
            SCanvas.Ellipse(round(Pano.Width*(i-1)/M),round(Pano.Height*(j-1)/N),
            round(Pano.Width*(i)/M),round(Pano.Height*(j)/N));
          end;
       end;
    end;
    SCanvas.Brush.Color:=$777777;
    SCanvas.Rectangle(round(Pano.Width*(pistonX)/M),0,round(Pano.Width*(pistonX+1)/M),Pano.Height);

end;

procedure TForm1.MEChange(Sender: TObject);
begin
     redimension;
     Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
end;

procedure TForm1.NEChange(Sender: TObject);
begin
    redimension;
     Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
end;

procedure TForm1.PanoClick(Sender: TObject);
begin
     Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);
 end;

procedure TForm1.PanoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
       X:=trunc(ME.Value*X/Pano.Width)+1;
       Y:=trunc(NE.Value*Y/Pano.Height)+1;
       points[X,Y]:=not points[X,Y];
       Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);

end;

procedure TForm1.PanoResize(Sender: TObject);
begin
//     Pano.Canvas.Height:=Pano.Height;
//     Pano.Canvas.Width:=Pano.Width;

     Form1.drawgrid(Pano.Canvas,NE.Value,ME.Value);

end;



end.

