--太阳神的使徒
function c18000004.initial_effect(c)
	--special summon
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18000004, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c18000004.target)
	e1:SetOperation(c18000004.operation)
	c:RegisterEffect(e1)

	local e2 = e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)

	local e3 = e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)

	--release limit
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	e4:SetValue(1)
	c:RegisterEffect(e4)

	local e5 = e4:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_SUM)
	e5:SetValue(c18000004.sumval)
	c:RegisterEffect(e5)
	--
	local e6 = Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1, 0)
	e6:SetTarget(c18000004.splimit)
	c:RegisterEffect(e6)
end

function c18000004.filter(c, e, tp)
	return c:IsCode(18000004) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end

function c18000004.target(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c18000004.filter, tp, LOCATION_DECK+LOCATION_HAND, 0, 1, nil, e, tp) end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_DECK+LOCATION_HAND)
end

function c18000004.operation(e, tp, eg, ep, ev, re, r, rp)
	local ft = Duel.GetLocationCount(tp, LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp, 59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp, c18000004.filter, tp, LOCATION_DECK+LOCATION_HAND, 0, 1, ft, nil, e, tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
	end
end

function c18000004.sumval(e, c)
	return not c:IsCode(18000001, 18000002, 18000003)
end

function c18000004.splimit(e, c, sump, sumtype, sumpos, targetp, se)
	return not se:GetHandler():IsCode(18000004)
end
