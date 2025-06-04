function [middleBand, upperBand, lowerBand] = myBollinger(data, FTSName, timeframe, currency, period, OHLC, plotparam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% myBollinger %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function calculates the Bollinger Band of a given dataset
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
% OHLC...Abbreviation of the column that should be displayed in the plot
%  O...Opening Price
%  H...High Price
%  H...Low Price
%  H...Closing Price
% plotparam...Flag that decides if the plot should be plotted
% Outputs
% middleBand...An array of the SMA values for the given period
% upperBand...The array of upper bound values for the bollinger band based 
% on the period
% lowerBand...The array of lower bound values for the bollinger band based
% on the period
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
    
    middleBand = mySMA(data, FTSName, timeframe, currency, period, OHLC, 0);
    stdDev = movstd(v, period);
    upperBand = middleBand + 2 * stdDev;
    lowerBand = middleBand - 2 * stdDev;
    
    if plotparam == 1
        figure;
        plot(v(period:end), 'k', 'DisplayName', 'Price');
        hold on;
        plot(middleBand(period:end), 'b', 'DisplayName', 'Middle Band (SMA)');
        plot(upperBand(period:end), 'g--', 'DisplayName', 'Upper Band');
        plot(lowerBand(period:end), 'r--', 'DisplayName', 'Lower Band');
        hold off;
        grid on;
        title([FTSName, ': ',text,' with Bollinger bands for period = ', num2str(period)]);
        xlabel(timeframe);
        ylabel(currency);
        legend('show');
    end

end