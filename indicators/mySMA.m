function SMA = mySMA(data, FTSname, TimeFrame,  Currency, period, OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%% help mySMA  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mySMA calculates the Simple Moving Average of the Time Period
% Inputs:
% data..........matrix of data (real), 5 columns: date(num),
%               open,high,low,close
% FTSname.......Name of the Financial Time Series
% TimeFrame.....Name of the Time Frame of the Data, e.g 'Daily',
%               'Weekly', '5 Min', ....
% Currency......Currency of Financial Time Series
% period........integer, length of time window of SMA
% OHLC..........string, "O" = Open,
%                        "H" = High,
%                        "L" = Low,
%                        "C" = Close.
% plotparam...  boolean if ==1 plot
%
% Outputs:
% SMA...        Simple Moving Average of the Time Series
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

% Define SMA
[s1, ~] = size(data);
SMA = zeros(s1,1);

% Calculate SMA
for idx = period:s1
    SMA(idx) = sum(v(idx-period+1:idx))/period;
end

% Plot Time Series with SMA
if plotparam == 1
    figure
    plot(v(period:s1))
    hold on
    plot(SMA(period:s1))
    hold off
    title([FTSname, ': ',txt,' and SMA, period = ', num2str(period)])
    xlabel(TimeFrame)
    ylabel(Currency)
    grid minor
end

