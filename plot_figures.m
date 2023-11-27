function plot_figures(fig,data)
% paper-ready figures

addpath([pwd '/mat/']);
cmap = brewermap(10,'Set1');
if nargin<2; load data_final.mat; end

% directory of figures
% exp1 is experiment 1 predictions and results

switch fig
    case 'example'
        agent.C = [0.23 0.23]; % capacity for both tasks
        agent.V = 0.7;

        plot_sim('test','heatmap',1, agent, 0.2) % task

    case 'task1'
        agent.C = [0.23 0.23]; % capacity for both tasks
        agent.V = 0.7;

        plot_sim('task1','heatmap',1, agent, 0.2) % task
        plot_sim('task1','main',1, agent, 0.2)    % policy compression model
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Main-Cost.pdf'], 'ContentType', 'vector');
        plot_sim('task1','main',3, agent, 0.2)    % standard RL / RLWM model
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Main-Vanilla.pdf'], 'ContentType', 'vector');

        analyze_data(fig,data,'main');            % data
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Main.pdf'], 'ContentType', 'vector');

        figure; hold on;
        analyze_data(fig,data,'action_biases');         % data
        plot_sim('task1','action_biases',1, agent, 0.2) % policy compression model
        plot_sim('task1','action_biases',3, agent, 0.2) % standard RL / RLWM model
        set(gcf, 'Position',  [300, 400, 750, 700])
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Biases.pdf'], 'ContentType', 'vector');

    case 'task2'
        agent.C = [0.27 0.24]; % capacity for both tasks
        agent.V = 0.75;
        plot_sim('task2','heatmap',1, agent, 0.25)
        plot_sim('task2','main',1, agent, 0.25) % capacity model
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Main-Cost.pdf'], 'ContentType', 'vector');
        agent.C = [0.22 0.25]; % capacity for both tasks
        plot_sim('task2','main',3, agent, 0.25) % vanilla model
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Main-Vanilla.pdf'], 'ContentType', 'vector');
        analyze_data(fig,data,'main'); % data
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Main.pdf'], 'ContentType', 'vector');

        figure; hold on;
        analyze_data(fig,data,'action_biases');
        plot_sim('task2','action_biases',1, agent, 0.25) % capacity model
        plot_sim('task2','action_biases',3, agent, 0.25) % vanilla model
        set(gcf, 'Position',  [300, 400, 750, 700])
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Biases.pdf'], 'ContentType', 'vector');

    case 'task3'
        agent.C = [0.27 0.14]; % capacity for both tasks
        agent.V = 0.71;
        plot_sim('task3','heatmap',1, agent, 0.3)
        plot_sim('task3','main',1, agent, 0.3) % capacity model
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Main-Cost.pdf'], 'ContentType', 'vector');
        plot_sim('task3','main',3, agent, 0.3) % vanilla model
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Main-Vanilla.pdf'], 'ContentType', 'vector');
        analyze_data(fig,data,'main'); % data
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Main.pdf'], 'ContentType', 'vector');

        figure; hold on;
        analyze_data(fig,data,'suboptimal');
        plot_sim('task3','suboptimal',1, agent, 0.3) % capacity model
        plot_sim('task3','suboptimal',3, agent, 0.3) % vanilla model
        set(gcf, 'Position',  [300, 400, 750, 700])
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Biases.pdf'], 'ContentType', 'vector');

    case 'dynamics' % plot all the raw data
        analyze_data('task1',data,'dynamic'); sgtitle('Data: Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics.pdf'], 'ContentType', 'vector');
        analyze_data('task2',data,'dynamic'); sgtitle('Data: Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics.pdf'], 'ContentType', 'vector');
        analyze_data('task3',data,'dynamic'); sgtitle('Data: Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics.pdf'], 'ContentType', 'vector');

        load simdata_cv;
        %load models_final; simdata_cv = sim_fitted('cv', data, results(8));
        analyze_data('task1',simdata_cv,'dynamic'); sgtitle('Policy compression model: Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics-Cost.pdf'], 'ContentType', 'vector');
        analyze_data('task2',simdata_cv,'dynamic'); sgtitle('Policy compression model: Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics-Cost.pdf'], 'ContentType', 'vector');
        analyze_data('task3',simdata_cv,'dynamic'); sgtitle('Policy compression model: Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics-Cost.pdf'], 'ContentType', 'vector');

    case 'complexity_bias'
        % subjects with lower complexity have higher bias towards marginal
        % higher lrate_p

        results(1) = analyze_data('task1',data,'action_biases');
        results(2) = analyze_data('task2',data,'action_biases');
        results(3) = analyze_data('task3',data,'suboptimal');

        cmap = brewermap(7,'Set3');
        figure; hold on; colororder(cmap(4:end,:))
        for t = 1:3
            nexttile; hold on;
            if t < 3
                plot(results(t).R_data(:,2),results(t).bias(:,2),'.','MarkerSize',20);
                plot(results(t).R_data(:,2),results(t).bias(:,3),'.','MarkerSize',20); lsline
                ylabel('Action bias'); xlabel('Policy complexity');
                [r,p] = corr(results(t).R_data(:,2),mean([results(t).bias(:,2) results(t).bias(:,3)],2));
                text(0.6,0.5,['R=' num2str(round(r,3)) ', p=' num2str(round(p,3)) ],'FontSize',15)
            else
                % for Task 3, decrease in complexity with time pressure predicts increased action slips / bias
                plot(results(t).R_data(:,1)-results(t).R_data(:,2),results(t).bias(:,3),'.','MarkerSize',20,'Color','k'); lsline
                ylabel('\DeltaP(suboptimal action)'); xlabel('Decrease in policy complexity')
                [r,p] = corr(results(t).R_data(:,1)-results(t).R_data(:,2),results(t).bias(:,3));
                text(-0.9,0.5,['R=' num2str(round(r,3)) ', p=' num2str(round(p,3)) ],'FontSize',15)
            end
            ylim([-1 1])
            title(['Task ' num2str(t)])
        end

        set(gcf, 'Position',  [300, 400, 1000, 300])
        exportgraphics(gcf,[pwd '/figures/raw/Complexity-Bias.pdf'], 'ContentType', 'vector');


    case 'collinsfrank18'
        [results, results_all] = analyze_collinsfrank18;

        cmap = brewermap(5,'Set3');
        figure; hold on; 
        Q = [1 0 0; 0 1 0; 0 1 0; 0 0 1];
        nexttile;
        h = heatmap({'A_1','A_2','A_3'},{'S_1','S_2','S_3','S_4'},Q);
        h.FontSize = 20;
        h.ColorbarVisible = false;

        for c = 2:6
            nexttile; hold on;colororder(cmap(2:end,:))
            b = barwitherr(sem(results.pref(:,:,c),1),nanmean(results.pref(:,:,c)));
            ylabel('P(A)'); set(gca,'XTick',[]);
            xticks([b.XEndPoints]); xticklabels({'A_1','A_2'})
            ylim([0.02 0.17]);
            title(['nS = ',num2str(c)])
            if c == 1
                legend('A_1','A_2')
            end
            d(c) = nanmean(results.pref(:,1,c)-results.pref(:,2,c));
            d_se(c) = sem(results.pref(:,1,c)-results.pref(:,2,c),1);
        end
        nexttile; hold on;
        errorbar(2:6,d(2:end),d_se(2:end)/2,d_se(2:end)/2);
        xlabel('Set size')
        ylabel('\Delta P(A)')
        title('P(A_1) - P(A_2)')
        xticks([2:6])
        axis([1 7 0.01 0.045])

        set(gcf, 'Position',  [300, 400, 1500, 220])

        exportgraphics(gcf,[pwd '/figures/raw/CollinsFrank18-Biases.pdf'], 'ContentType', 'vector');

        %         figure; hold on;
        %         nexttile; hold on;
        %         errorbar(2:6,nanmean(results.R_data(:,2:end)),sem(results.R_data(:,2:end),1)/2,sem(results.R_data(:,2:end),1)/2,'color',cmap(a,:));
        %         xlabel('Set size')
        %         xticks([2:6])
        %         axis([1 7 0.3 0.6])
        %         ylabel('Policy complexity')
        %
        %         nexttile; hold on;
        %         errorbar(2:6,nanmean(results.V_data(:,2:end)),sem(results.V_data(:,2:end),1)/2,sem(results.V_data(:,2:end),1)/2);
        %         xlabel('Set size')
        %         xticks([2:6])
        %         axis([1 7 0.7 0.9])
        %         ylabel('Average reward')
        %
        %
        %         nexttile; hold on;
        %         for a = 1:2
        %             errorbar(2:6,nanmean(squeeze(results.sub(:,a,2:end))),sem(squeeze(results.sub(:,a,2:end)),1)/2,sem(squeeze(results.sub(:,a,2:end)),1)/2,'color',cmap(a+1,:));
        %         end
        %         xlabel('Set size')
        %         xticks([2:6])
        %         ylabel('P(suboptimal actions)')
        %         axis([1 7 0.06 0.14])


    case 'supp: beta dynamics'
        load models_final; simdata_test = sim_fitted('cv', data, results(8));
        figure;
        dC = nan(200,150,2);
        dV = nan(200,150,2);
        beta = nan(200,150,2);
        for t = 1:3
            for s = 1:length(simdata_test)
                data = simdata_test(s).exp(t);
                for c = 1:2
                    ix = find(data.cond==c);
                    dC(s,1:length(data.dC(ix)),c) = data.dC(ix);
                    dV(s,1:length(data.dV(ix)),c) = data.dV(ix);

                    %RT = data.rt(ix);
                    %rt(s,c) = mean(RT);
                    beta(s,1:length(data.beta(ix)),c) = data.beta(ix);
                    %beta_data(s,c) = mean(data.beta(ix));
                    %R_data(s,c) = mutual_information(state, action ,0.1);
                    %V_data(s,c) = mean(reward);

                end % condition
            end % subject
            for c = 1:2
                nexttile;hold on;
                plot(mean(dC(:,:,c)));plot(mean(dV(:,:,c)))
                plot(mean(beta(:,:,c)))
                legend('dC','dV','\beta')
            end
            clear dC dV beta
        end

        load models_final; load data_final;
        simdata_test = sim_fitted('capacity', data, results(6));
        figure;
        dC = nan(200,150,2);
        dV = nan(200,150,2);
        beta = nan(200,150,2);
        for t = 1:3
            for s = 1:length(simdata_test)
                data = simdata_test(s).exp(t);
                for c = 1:2
                    ix = find(data.cond==c);
                    dC(s,1:length(data.dC(ix)),c) = data.dC(ix);

                    %RT = data.rt(ix);
                    %rt(s,c) = mean(RT);
                    beta(s,1:length(data.beta(ix)),c) = data.beta(ix);
                    %beta_data(s,c) = mean(data.beta(ix));
                    %R_data(s,c) = mutual_information(state, action ,0.1);
                    %V_data(s,c) = mean(reward);

                end % condition
            end % subject
            for c = 1:2
                nexttile;hold on;
                plot(mean(dC(:,:,c)));
                plot(mean(beta(:,:,c)))
                legend('dC','\beta')
            end
            clear dC beta
        end

        load models_final; load data_final;
        simdata_test = sim_fitted('value', data, results(7));
        figure;
        dV = nan(200,150,2);
        beta = nan(200,150,2);
        for t = 1:3
            for s = 1:length(simdata_test)
                data = simdata_test(s).exp(t);
                for c = 1:2
                    ix = find(data.cond==c);
                    dV(s,1:length(data.dV(ix)),c) = data.dV(ix);

                    %RT = data.rt(ix);
                    %rt(s,c) = mean(RT);
                    beta(s,1:length(data.beta(ix)),c) = data.beta(ix);
                    %beta_data(s,c) = mean(data.beta(ix));
                    %R_data(s,c) = mutual_information(state, action ,0.1);
                    %V_data(s,c) = mean(reward);

                end % condition
            end % subject
            for c = 1:2
                nexttile;hold on;
                plot(mean(dV(:,:,c)));
                plot(mean(beta(:,:,c)))
                legend('dV','\beta')
            end
            clear dV beta
        end

    case 'supp: model comparison'
        load models_FINAL
        models_labels = {'RLWM','No Cost (1\beta)','No Cost (6\beta)','Fixed (1\beta)','Fixed (6\beta)','Capacity','Value','Capacity-Value'};

        figure; hold on;
        y = mean([results.bic]);
        y = y-min(y);
        [~,idx] = sort(y);
        cmap = brewermap(10,'YlGnBu');
        for m = idx
            bar(find(m==idx),y(m),'FaceColor',cmap(find(m==idx),:));
            errorbar(find(m==idx),y(m),sem(results(m).bic,1)/2,sem(results(m).bic,1)/2)
        end
        ylabel('\Delta BIC from best model');
        yticks([0 2000 4000 6000 8000]);ylim([0 8000])
        xticks(1:length(results)); xticklabels(models_labels(idx))
        exportgraphics(gcf,[pwd '/figures/raw/Model-Comparison.pdf'], 'ContentType', 'vector');

    case 'supp: dynamics' % plot all the raw data
        % value model
        load models_FINAL;
        simdata_v = sim_fitted('value', data, results(7));
        analyze_data('task1',simdata_v,'dynamic'); sgtitle('Policy Compression (Adaptive: Value): Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics-Value.pdf'], 'ContentType', 'vector');
        analyze_data('task2',simdata_v,'dynamic'); sgtitle('Policy Compression (Adaptive: Value): Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics-Value.pdf'], 'ContentType', 'vector');
        analyze_data('task3',simdata_v,'dynamic'); sgtitle('Policy Compression (Adaptive: Value): Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics-Value.pdf'], 'ContentType', 'vector');

        load simdata_c;
        analyze_data('task1',simdata_c,'dynamic'); sgtitle('Policy Compression (Adaptive: Capacity): Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics-Capacity.pdf'], 'ContentType', 'vector');
        analyze_data('task2',simdata_c,'dynamic'); sgtitle('Policy Compression (Adaptive: Capacity): Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics-Capacity.pdf'], 'ContentType', 'vector');
        analyze_data('task3',simdata_c,'dynamic'); sgtitle('Policy Compression (Adaptive: Capacity): Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics-Capacity.pdf'], 'ContentType', 'vector');

        % fixed model (without fitting an additional parameter for Task 3)
        load simdata_f2;
        analyze_data('task1',simdata_f2,'dynamic'); sgtitle('Policy Compression (Fixed 1\beta): Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics-Fixed.pdf'], 'ContentType', 'vector');
        analyze_data('task2',simdata_f2,'dynamic'); sgtitle('Policy Compression (Fixed 1\beta): Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics-Fixed.pdf'], 'ContentType', 'vector');
        analyze_data('task3',simdata_f2,'dynamic'); sgtitle('Policy Compression (Fixed 1\beta): Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics-Fixed.pdf'], 'ContentType', 'vector');

        % rlwm model
        load simdata_rlwm;
        analyze_data('task1',simdata_rlwm,'dynamic'); sgtitle('RLWM: Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics-RLWM.pdf'], 'ContentType', 'vector');
        analyze_data('task2',simdata_rlwm,'dynamic'); sgtitle('RLWM: Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics-RLWM.pdf'], 'ContentType', 'vector');
        analyze_data('task3',simdata_rlwm,'dynamic'); sgtitle('RLWM: Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics-RLWM.pdf'], 'ContentType', 'vector');

        % no cost model
        load simdata_nc;
        analyze_data('task1',simdata_nc,'dynamic'); sgtitle('Standard RL: Task 1')
        exportgraphics(gcf,[pwd '/figures/raw/Task1-Dynamics-NC.pdf'], 'ContentType', 'vector');
        analyze_data('task2',simdata_nc,'dynamic'); sgtitle('Standard RL: Task 2')
        exportgraphics(gcf,[pwd '/figures/raw/Task2-Dynamics-NC.pdf'], 'ContentType', 'vector');
        analyze_data('task3',simdata_nc,'dynamic'); sgtitle('Standard RL: Task 3')
        exportgraphics(gcf,[pwd '/figures/raw/Task3-Dynamics-NC.pdf'], 'ContentType', 'vector');




end
end