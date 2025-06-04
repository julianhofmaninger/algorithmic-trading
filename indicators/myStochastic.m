function [stochastic, signalLine] = myStochastic(data, FTSName, timeframe, currency, period, SMAperiod, OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% myStochastic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the STochastic Oscillator of a given dataset
% Inputs
% data...The dataset containing five columns in the following order
%  1. Timestamp
%  2. Opening Price
%  3. High Price
%  4. Low Price
%  5. Closing Price
% FTSName...The name of the dataset (e.g. name of the stock)
% timeframe...The timeframe of the data (e.g. hourly, daily, weekly,...)
% currency...The Currency of the price values
% period...The period of the EMA to be calculated
% SMAperiod...The period for calculating the signal line based on a SMA
% calculation of the SMA
% OHLC...Abbreviation of the column that should be displayed in the plot
%  O...Opening Price
%  H...High Price
%  H...Low Price
%  H...Closing Price
% plotparam...Flag that decides if the plot should be plotted
% Outputs
% Stochastic...An array of the Stochastic for each given timestamp of the data starting
% from the period element
% Signal...An array of the Signal line for each given timestamp of the data starting
% from the period element
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if OHLC == "O"
        v = data(:,2);
        text = 'Open Price';
    elseif OHLC == "H"
        v = data(:,3);
        text = 'High Price';
    elseif OHLC == "L"
        v = data(:,4);
        text = 'Low Price';
    elseif OHLC == "C"
        v = data(:,5);
        text = 'Closing Price';
    end

    [s1,~] = size(data);
    
    stochastic = zeros(s1, 1);
    
    for i=period+1:s1
        from = i-period;
        to = i;
        highestHigh = max(data(from:to, 3));
        lowestLow = min(data(from:to, 4));
        today = data(i,5);
        if highestHigh ~= lowestLow
            stochastic(i) = (today - lowestLow) / (highestHigh - lowestLow) * 100;
        else
            stochastic(i) = 0;  
        end
    end
    
    s(:,2) = stochastic;
    signalLine = mySMA(s, "", "", "", SMAperiod, "O", 0);

    if plotparam == 1
        figure
        ax1 = subplot(2,1,1);
        plot(v(period+1:end));
        title([FTSName, ': ',text,' and RSI period = ', num2str(period)]);
        xlabel(timeframe);
        ylabel(currency);
        
        ax2 = subplot(2,1,2);
        hold on;
        plot(stochastic(period:end), 'b', 'DisplayName', '%K Line');
        plot(signalLine(period:end), 'r', 'DisplayName', '%D Line');
        yline(80, '--k');  % Overbought level
        yline(20, '--k');  % Oversold level
        legend;
        hold off;
        xlabel(timeframe);
        ylabel('Stochastic Value');
        grid minor;
        linkaxes([ax1, ax2], 'x');
    end

end