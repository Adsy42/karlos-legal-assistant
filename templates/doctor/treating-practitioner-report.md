[TONE: clinical_specific] [DOCUMENT-TIER: 1]
{{today}}
[INSTRUCTION: Doctor name/address from parties array]

Dear Doctor,
Re: {{client.full_name}} | DOB: {{client.date_of_birth}} | DOI: {{dates.date_of_injury}} | Ref: {{matter_id}}

We act for the above patient in their {{claim_type}} claim arising from {{injury.mechanism}}. Enclosed: signed authority.

[INSTRUCTION: Select questions from reference/medical-questions.md appropriate to claim type, body parts, stage. Include specific questions for any active flags or disputes.]

Our client authorises that your fee will be met [INSTRUCTION: WorkCover → "by the insurer" / other → "by our office"].

We would appreciate your report within 28 days.

Yours faithfully, {{firm.name}} | Mandy, Senior Associate
Enc: Authority to Release Medical Records
