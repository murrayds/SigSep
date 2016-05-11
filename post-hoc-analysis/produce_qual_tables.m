load_qual_data

SS_COLUMN = 2;
CSV_OUTPUT_PATH = sprintf('%s\\qual_csvs\\', pwd);
PARAM_NAMES = {'Scenario', 'Algorithm', 'NFFT', 'Components'};
RESPONSE_NAMES = {'TRAINTIME', 'SEPTIME'};

anova1_tbl = cell(size(PARAMS, 2), size(RESPONSE, 2));
anova1_p = cell(size(PARAMS, 2), size(RESPONSE, 2));
anova1_stats = cell(size(PARAMS, 2), size(RESPONSE, 2));
anova1_T = cell(size(PARAMS, 2), size(RESPONSE, 2));

for res = 1:size(RESPONSE, 2)
    % create the output directory for this response variable
    csv_dir = sprintf('%s%s%s\\', CSV_OUTPUT_PATH, 'anova1\\', RESPONSE_NAMES{res});
    mkdir(csv_dir);
    for par = 1:size(PARAMS, 2)
        param_var = PARAMS(:, par);
        response_var = RESPONSE(:, res);
        [p, tbl, stats] = anova1(response_var, param_var, 'off');
        
        % get total variance
        total_variance = tbl{4, 2};
        variance_column = cell(4, 1);
        variance_column{1} = 'Percent_Variance';
        
        for i = 2:3
           portion_variance = tbl{i, SS_COLUMN} / total_variance;
           variance_column{i} = portion_variance;
        end
            
        % append the new %variance column to the table
        tbl = [tbl, variance_column]; %#ok<AGROW>
        
        % now convert tbl to an actual matlab table, which can be easily
        % written to a .csv file
        tbl{1, 6} = 'P_value';
        T = cell2table(tbl(2:end,:));
        T.Properties.VariableNames = tbl(1,:);
        
        pname = PARAM_NAMES{par};
        rname = RESPONSE_NAMES{res};
        
        table_filepath = sprintf('%sone-way-anova-csv-%s-%s.csv', csv_dir, pname, rname);
        writetable(T, table_filepath)
        
        % save the output values from the one-way anova computation
        anova1_p{par, res} = p;
        anova1_tbl{par, res} = tbl;
        anova1_stats{par, res} = stats;
        anova1_T{par, res} = T;
    end
end

TOTAL_VARIANCE_ROW = 18;

anovan_tbl = cell(1, size(RESPONSE, 2));
anovan_p = cell(1, size(RESPONSE, 2));
anovan_stats = cell(1, size(RESPONSE, 2));
anovan_T = cell(1, size(RESPONSE, 2));

for res = 1:size(RESPONSE, 2)
    csv_dir = sprintf('%s%s\\', CSV_OUTPUT_PATH, 'anovan');
    mkdir(csv_dir)
    
    response_var = RESPONSE(:, res);
    [p, tbl, stats] = anovan(response_var, PARAMS, 'varnames', PARAM_NAMES, 'display', 'off', 'model', 'full');
    
    total_variance = tbl{TOTAL_VARIANCE_ROW, SS_COLUMN};
    variance_column = cell(18, 1);
    variance_column{1} = 'Percent_Variance';
    
    for i = 2:17
           portion_variance = tbl{i, SS_COLUMN} / total_variance;
           variance_column{i} = portion_variance;
    end
    
    % append the new %variance column to the table
    tbl = [tbl, variance_column]; %#ok<AGROW>
    
    % remove the `Singular?` column
    tbl(:, 4) = [];
    
    % now convert tbl to an actual matlab table, which can be easily
    % written to a .csv file. Make titles work ok. 
    tbl{1, 2} = 'Sum_Sq';
    tbl{1, 3} = 'df';
    tbl{1, 4} = 'Mean_Sq';
    
    tbl{1, 6} = 'P_value';
    T = cell2table(tbl(2:end,:));
    T.Properties.VariableNames = tbl(1, :);
        
    pname = PARAM_NAMES{par};
    rname = RESPONSE_NAMES{res};
        
    table_filepath = sprintf('%sn-way-anova-csv-%s.csv', csv_dir, rname);
    writetable(T, table_filepath)
    
    anovan_p{res} = p;
    anovan_tbl{res} = tbl;
    anovan_stats{res} = stats;
    anovan_T{res} = T;
end

