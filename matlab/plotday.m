%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%        Copyright (c) 2017 Carsten Wulff Software, Norway 
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Created       : wulff at 2017-10-14
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   This program is free software: you can redistribute it and/or modify
%%   it under the terms of the GNU General Public License as published by
%%   the Free Software Foundation, either version 3 of the License, or
%%   (at your option) any later version.
%% 
%%   This program is distributed in the hope that it will be useful,
%%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%%   GNU General Public License for more details.
%% 
%%   You should have received a copy of the GNU General Public License
%%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data=plotday(file);

data = dlmread(file,";");



%avg1 = filter(ones(150,1)/150,1,data(:,2)); % 10 min average

%avg2 = filter(ones(900,1)/900,1,data(:,2)); % 1 hour average

x = (data(:,1) - data(1,1))/(60*60); %Hours

setenv("GNUTERM","X11")
figure1 = figure(1);


%- Make average per hour
hour_mean = zeros(1,24);
for i=1:length(data(:,2))
  time = localtime(data(i,1));
  val = data(i,2);
  hour_mean(time.hour+1) = (hour_mean(time.hour+1) + val)/2;
end

%- Make average per hour
half_hour_mean = zeros(1,48);
for i=1:length(data(:,2))
  time = localtime(data(i,1));
  val = data(i,2);
  if(time.min >= 30) 
	half_hour_mean(time.hour*2+2) = (half_hour_mean(time.hour*2+2) + val)/2;
  else
	half_hour_mean(time.hour*2+1) = (half_hour_mean(time.hour*2+1) + val)/2;
  end
end

hour_x = (1:1:24);
half_hour_x = (0.5:0.5:24);



date = strftime ('%Y-%m-%d', localtime (data(1,1)))

mm = mean(data(:,2))



subplot(2,1,1);
hold on;
plot(x,data(:,2)/1000,'Color',[0.9 0.9 0.9]);
%plot(x,avg1/1000,'b');
%plot(x,avg2/1000,'r');
stairs(half_hour_x,half_hour_mean/1000,'b');
hold off;
xlabel('Time [h]');
ylabel('Power [kw]');
title([date," Average=",sprintf('%.2f',mm/1000)," kW"," Total=",sprintf('%.2f',mm/1000*24)," kWh"]);
axis([0 24 0 15])
set(gca,"xtick",(1:1:24))
adorne
subplot(2,1,2),stairs(hour_x,hour_mean/1000,'r');
xlabel('Time [h]');
ylabel('Power [kw]');
set(gca,"xtick",(1:1:24))
axis([0 24 0 max(hour_mean/1000)])
adorne
saveas(figure1,[file,".pdf"]);
