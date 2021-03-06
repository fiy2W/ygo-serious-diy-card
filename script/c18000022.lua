--电子暗黑刃翼
function c18000022.initial_effect(c)
	--equip
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18000022, 0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c18000022.eqtg)
	e1:SetOperation(c18000022.eqop)
	c:RegisterEffect(e1)
	--damage
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
	--
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_ATTACK_FINAL)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c18000022.atkcon)
	e3:SetValue(c18000022.atkval)
	c:RegisterEffect(e3)
end

function c18000022.filter(c)
	return c:IsLevelBelow(3) and (c:IsRace(RACE_DRAGON) or c:IsRace(RACE_MACHINE)) and not c:IsForbidden()
end

function c18000022.eqtg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c18000022.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
	local g = Duel.SelectTarget(tp, c18000022.filter, tp, LOCATION_GRAVE,LOCATION_GRAVE, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_EQUIP, g, 1, 0, 0)
end

function c18000022.eqop(e, tp, eg, ep, ev, re, r, rp)
	if Duel.GetLocationCount(tp, LOCATION_SZONE)<=0 then return end
	local c = e:GetHandler()
	local tc = Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		local atk = tc:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp, tc, c, false) then return end
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c18000022.eqlimit)
		tc:RegisterEffect(e1)
		local e2 = Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
		local e3 = Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DESTROY_SUBSTITUTE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(c18000022.repval)
		tc:RegisterEffect(e3)
	end
end

function c18000022.eqlimit(e, c)
	return e:GetOwner()==c
end

function c18000022.repval(e, re, r, rp)
	return bit.band(r, REASON_BATTLE)~=0
end

function c18000022.atkcon(e)
	local tp = e:GetHandlerPlayer()
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL
		and Duel.GetAttackTarget()==nil and Duel.GetFieldGroupCount(tp, 0, LOCATION_MZONE)~=0
		and e:GetHandler():GetEffectCount(EFFECT_DIRECT_ATTACK)==1
end

function c18000022.atkval(e, c)
	return c:GetAttack()/2
end