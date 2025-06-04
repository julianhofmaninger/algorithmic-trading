function EMA = myEMA(data, FTSname, TimeFrame,  Currency, period, OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%% help myEMA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% myEMA calculates the Exponential Moving Average of the Time Period
% Inputs:
% data..........matrix of data (real), 5 columns: date(num),
%               open,high,low,close
% FTSname.......Name of the Financial Time Series
% TimeFrame.....Name of the Time Frame of the Data, e.g 'Daily',
%               'Weekly', '5 Min', ....
% Currency......Currency of Financial Time Series
% period........integer, length of time window of EMA
% OHLC..........string, "O" = Open,
%                        "H" = High,
%                        "L" = Low,
%                        "C" = Close.
% plotparam.....boolean if ==1 plot
%
% Outputs:
% EMA...........Exponential Moving Average of the Time Series
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Prepare data
if OHLC == "O"
    v = data(:,2);
    txt = 'Open Price';
elseif OHLC == "H"
    v = data(:,3);
    txt = 'High Price';
elseif OHLC == "L"
    v = data(:,4);
    txt = 'Low Price';
elseif OHLC == "C"   
    v = data(:,5);
    txt = 'Closing Price';
end

% Define EMA and multiplier
[s1, ~] = size(data);
EMA = zeros(s1,1);
multiplier = 2 / (period+1);

% Calculate EMA
EMA(period) = mean(v(1:period));
for ii = period+1 : s1
    EMA(ii) = (v(ii)-EMA(ii-1)) * multiplier + EMA(ii-1);
end

% Plot Time Series with EMA
if plotparam == 1
    f1 = figure;
	f1.Position = [200 100 1400 800];
    plot(v(period:s1),'b')
    hold on
    plot(EMA(period:s1),'r')
    hold off
    xlabel(TimeFrame)
    ylabel(Currency)
    title([FTSname,' : ', txt,' and Exponential Moving Average, period = ',num2str(period)])
    grid minor
end