program  Gas;

uses 
    Sysutils;

type

  dir = array [1..2] of integer;

var
  points: array [-2001..2001] of array [-2001..2001] of boolean;
  xpoints: array [-2001..2001] of array [-2001..2001] of boolean;
  dirs: array [-2001..2001] of array [-2001..2001] of dir;
  adirs: array [-2001..2001] of array [-2001..2001] of dir;
  probs: array [-1..1] of array [-1..1] of real;
  sumprobs:array [-1..1] of array [-1..1] of real;
  ME_Value,NE_Value,MEL_Value,NEL_Value: integer;
  i: integer;
  state: integer;
  SCount: integer;
  draw : boolean;
  out: TextFile;

procedure reprob();
var i,j:integer;
  s:real;
begin

    s:=-probs[0,0];
     for i:=-1 to 1 do begin
         for j:=-1 to 1 do begin
           s+=probs[i,j];
         end;
     end;
    probs[0,0]:=1-s;

    s:=0;
     for i:=-1 to 1 do begin
         for j:=-1 to 1 do begin
           s+=probs[i,j];
           sumprobs[i,j]:=s;
         end;
     end;

end;

function gendir() :dir;
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


procedure Step1Click();
var i,j,ip,jp,M,N,ML,NL:integer;
  l:real;
begin
  M:=ME_Value; N:=NE_Value; NL:=NEL_Value; ML:=MEL_Value;
  for i:=ML to M do begin
    for j:=NL to N do begin
      if points[i,j] then begin
       dirs[i,j]:=gendir();
      end;
    end;
  end;
end;

procedure Step3Click();
var i,j,M,N,ML,NL:integer;
  d: dir;
begin
  M:=ME_Value; N:=NE_Value;   NL:=NEL_Value; ML:=MEL_Value;
//writeln(M,' ',N,' ',ML,' ',NL);
  for i:=ML to M do begin
    for j:=NL to N do begin
      if points[i,j] then begin
       d:=adirs[i,j];
//writeln(i,j);
        if  ((adirs[i+d[1],j+d[2],1]=-d[1]) and (adirs[i+d[1],j+d[2],2]=-d[2])) then continue;
       points[i,j]:=false;
       points[i+d[1],j+d[2]]:=true;
      end;
    end;
  end;
        for i:=-2001 to 2001 do begin
           for j:=-2001 to 2001 do begin
             dirs[i,j,1]:=0; dirs[i,j,2]:=0;
           end;
        end;

  SCount:=SCount+1;
end;




procedure start;
var i,j:integer;
begin
          ME_Value:=2000;
          NE_Value:=2000;
	  MEL_Value:=0;
	  NEL_Value:=0;


        for i:=-2001 to 2001 do begin
           for j:=-2001 to 2001 do begin
              points[i,j]:=false;
              dirs[i,j,1]:=0; dirs[i,j,2]:=0;
           end;
        end;
        probs[-1,-1]:=0; probs[-1,1]:=0; probs[1,-1]:=0; probs[1,1]:=0;
        probs[1,0]:=0; probs[0,1]:=0; probs[-1,0]:=0.5; probs[0,-1]:=0.5;
        probs[0,0]:=0;
	reprob;
        SCount:=0;

end;

procedure Step2Click();
var i,j,ip,jp,M,N,ML,NL,nM,nN,nML,nNL,k,l,v,s:integer;
  d: dir;
  vv: array [1..9] of dir;
  count,countmov:integer;
  r,ll: real;
begin
//Memo1.Text:='';
  M:=ME_Value; N:=NE_Value;   NL:=NEL_Value; ML:=MEL_Value;
  nN:=N;nM:=M;nML:=ML;nNL:=NL;
  count:=0; countmov:=0;
         for i:=-2001 to 2001 do begin
           for j:=-2001 to 2001 do begin
             adirs[i,j,1]:=0; adirs[i,j,2]:=0;
 //            adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
               xpoints[i,j]:=points[i,j];
           end;
        end;
  for i:=ML to M do begin
    for j:=NL to N do begin
          adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
     end;
   end;
  for i:=ML to M do begin
    for j:=NL to N do begin
      if points[i,j] then begin
       count:=count+1;
       d:=dirs[i,j];


        if ((adirs[i,j,1]=0) and (adirs[i,j,2]=0)) and xpoints[i,j] then begin

          continue;

         end
        else if not xpoints[i,j] then begin
          if not(( adirs[i,j,1]=0) and ( adirs[i,j,2]=0)) then begin

                 countmov:=countmov+1;
          end;
//          GraphUtil.DrawArrow(Pano.Canvas,p,q);
          continue;
        end

        else begin
//       if (adirs[i,j,1]=0) and (adirs[i,j,2]=0) then continue;
      adirs[i,j,1]:=0; adirs[i,j,2]:=0;
       if i+d[1]>M then nM:=M+1;//continue;
       if j+d[2]>N then nN:=N+1;//continue;
       if i+d[1]<=ML then nML:=ML-1;//continue;
       if j+d[2]<=NL then nNL:=NL-1;//continue;

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
//              if not ((i+d[1]+k>M)or (i+d[1]+k<=0)or (j+d[2]+l>N)
//                     or (j+d[2]+l<=0)) then begin
                        if points[i+d[1]+k,j+d[2]+l] then begin
                           if (dirs[i+d[1]+k,j+d[2]+l,1]=-k) and (dirs[i+d[1]+k,j+d[2]+l,2]=-l) then begin
                              v:=v+1;
                              vv[v,1]:=k; vv[v,2]:=l;

                           end;
                        end;
//              end;
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
          continue;
       end;
       adirs[i,j,1]:=dirs[i,j,1]; adirs[i,j,2]:=dirs[i,j,2];
       countmov:=countmov+1;

        end;
      end;
    end;
  end;
  countmov:=0;
  for i:=ML to M do begin
     for j:=NL to N do begin
         if points[i,j] then
                if not ((adirs[i,j,1]=0) and (adirs[i,j,2] =0)) then
                       countmov:=countmov+1;
     end;
  end;
  ME_Value:=nM; MEL_Value:=nML; NE_Value:=nN; NEL_Value:=nNL;
end;

procedure RandClick(p: Single);
var i,j:integer;
begin
     for i:=MEL_Value to ME_Value do begin
       for j:=NEL_Value to NE_Value do begin
         points[i,j]:= random()<=p;
       end;
     end;
     SCount:=0;

end;

procedure printdata();
var k,i,j,s:integer;
begin
    for k:=0 downto MEL_Value+NEL_Value do begin
	s:=0;
	for i:=MEL_Value to k-NEL_Value do begin
	    if points[i,k-i] then s:=s+1;
	end;
	write(out,s,';');
    end;
    writeln(out);
end;

begin
	Assign(out,'out/'+FloatToStr((Now - EncodeDate(1970, 1 ,1)) * 24 * 60 * 60)+'.out');
	rewrite(out);
	start();
	RandClick(1.0);
	for i:=1 to 1000 do begin
    	    Step1Click();
    	    Step2Click();
    	    Step3Click();
	    write(out,SCount,';');
	    printdata();
	end;
	Close(out);
end.

