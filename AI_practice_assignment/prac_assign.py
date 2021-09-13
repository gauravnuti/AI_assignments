# forward chaining rule engine
# trying out durable rules engine
#
from durable.lang import *

with ruleset('start'):
    # will be triggered by 'interests' facts
    @when_all((m.interests == 'ML') & (m.grade == '9') & (m.pref == 'theory'))
    def hci(c):
        c.assert_fact('skills', { 'field': 'probability' })
        c.assert_fact({ 'subject': 'Take elective ML course.' })
        c.assert_fact('preference', { 'type': 'ML theory'})

    @when_all((m.interests == 'DL') & (m.grade == '9') )
    def hci(c):
        c.assert_fact('skills', { 'field': 'probability' })
        c.assert_fact({ 'subject': 'Take DL course.' })

    @when_all((m.interests == 'Developement') & (m.grade == '9') & (m.pref == 'practical'))
    def hci(c):
        c.assert_fact('skills', { 'field': 'Coding' })
        c.assert_fact({ 'subject': 'Take elective SDOS course.' })
        c.assert_fact('preference', { 'type': 'Developement'})

    @when_all(+m.subject)
    def output(c):
        print('Fact: {0}'.format(c.m.subject))


with ruleset('skills'):
    @when_all((m.field == 'probability'))
    def mathc(d):
        d.assert_fact({ 'subject': 'Take Probability and Statistics course' })

    @when_all((m.field == 'Coding'))
    def mathc(d):
        d.assert_fact({ 'subject': 'Take AP course' })

    @when_all(+m.subject)
    def output(d):
        print('Fact: {0}'.format(d.m.subject))

with ruleset('preference'):
    @when_all((m.type == 'ML theory'))
    def mathct(e):
        e.assert_fact({ 'subject': 'Take Advanced ML theory course'})

    @when_all((m.type == 'Developement'))
    def mathct(e):
        e.assert_fact({ 'subject': 'Do an internship'})


    @when_all(+m.subject)
    def output(c):
        print('Fact: {0}'.format(c.m.subject))

l = [{ 'interests': 'ML', 'grade': '9', 'pref':'theory' }, { 'interests': 'Developement', 'grade': '9', 'pref':'practical' }]
for i in l:
    print('For interest: '+i['interests']+' grade: '+i['grade']+' preference: '+i['pref'])
    assert_fact('start',i)
    print()