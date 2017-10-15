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
avg1 = filter(ones(150,1)/150,1,data(:,2)); % 10 min average

avg2 = filter(ones(900,1)/900,1,data(:,2)); % 1 hour average

x = (data(:,1) - data(1,1))/(60*60); %Hours

setenv("GNUTERM","X11")
figure1 = figure(1);
date = ctime(data(1,1));
date = strftime ('%Y-%m-%d', localtime (data(1,1)))

mm = mean(data(:,2))

hold on;
plot(x,data(:,2)/1000,'Color',[0.9 0.9 0.9]);
plot(x,avg1/1000,'b');
plot(x,avg2/1000,'r');
xlabel('Time [h]');
ylabel('Power [kw]');
title([date," Average=",sprintf('%.2f',mm/1000)," kW"]);
axis([0 24 0 15])
adorne
saveas(figure1,[file,".pdf"]);
hold off;
