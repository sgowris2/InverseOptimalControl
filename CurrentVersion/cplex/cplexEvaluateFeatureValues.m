function [featureArray] = cplexEvaluateFeatureValues(x)

global xExpertCombined;
global noOfCycles;
global noOfPhasesInACycle;
global phaseSequence;
global noOfLinks;
global featureSelection;
global mandatoryPhases;
global zeroTimePhases;

m = noOfLinks;

[l,t,delta] = xIndexing(noOfLinks,noOfCycles{1}*noOfPhasesInACycle);

% J{1} = objJ1_allQ(l,numel(xExpertCombined));
% J{2} = objJ2_cycleLength(delta,noOfCycles{1},noOfPhasesInACycle,numel(xExpertCombined));
% for i = 1:noOfLinks
%     J{i+2} = objJ_queueLength(i,l,numel(xExpertCombined));
% end
% for i = 1:numel(phaseSequence)
%     J{i+10} = objJ_phaseLength(i,xExpertCombined,phaseSequence,delta,noOfCycles{1},numel(xExpertCombined));
% end
% for i = 1:numel(phaseSequence)
%     [J{i+18} f{i+18} g{i+18}] = objJ_phaseAvgLength(i,xExpertCombined,phaseSequence,delta,numel(xExpertCombined));
% end
% for i = 1:numel(phaseSequence)
%     [J{i+26} f{i+26}] = objJ_phaseLengthL1(i,phaseSequence,delta,numel(xExpertCombined));
% end
% for i = 1:noOfLinks
%     [J{i+34} f{i+34}] = objJ_queueLengthL1(i,l,numel(xExpertCombined));
% end
% for i = 2:2:noOfLinks
%     [J{i+42} f{i+42}] = objJ_leftTurnPenalty(i,mandatoryPhases,l,numel(xExpertCombined),phaseSequence);
% end

J{1} = objJ2_cycleLength(delta,noOfCycles{1},noOfPhasesInACycle,numel(xExpertCombined));
for i = 1:numel(phaseSequence)
    J{i+1} = objJ_phaseLength(i,zeroTimePhases,phaseSequence,delta,noOfCycles{1},numel(xExpertCombined));
end
for i = 1:m
    [J{i+9} f{i+9}] = objJ_queueLengthL1(i,l,numel(xExpertCombined));
end
for i = 1:m
    [J{i+17}]= objJ_queueLength(i,l,numel(xExpertCombined));
end
for i = 1:numel(phaseSequence)
    [J{i+25} f{i+25} g{i+25}] = objJ_phaseAvgLength(i,xExpertCombined,phaseSequence,delta,numel(xExpertCombined));
end

for i = 1:numel(J)   
    if numel(J) >= i
        if numel(J{i})>1 && numel(f{i})>1
            featureArray(i) = featureSelection(i) * (x'*J{i}*x + f{i}*x);
        elseif numel(J{i})>1 && numel(f{i})<1
            featureArray(i) = featureSelection(i) * x'*J{i}*x;
        elseif numel(J{i})<1 && numel(f{i})>1
            featureArray(i) = featureSelection(i) * f{i}*x;
        else
            featureArray(i) = 0;
        end
        if numel(g) >= i
            if numel(g{i}) == 1
                featureArray(i) = featureArray(i) + g{i};
            end
        end
    end
end

