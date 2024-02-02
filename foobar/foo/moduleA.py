#TODO - use type hinting
#FIXME - blah blah

"""
DocString Example in ModuleA
"""
class SequenceOn:
   autonumber = True
   init_done = False

class B:
    def __init__(self):
        pass

    def funcB1(self):
        s = SequenceOn()

    def funcB2(self):
        s = SequenceOn()
        s.note("calling private method")
        self.__funcB22()

    def __funcB22(self):
        s = SequenceOn()

class A:
    def __init__(self):
        pass
    def funcA(self):

        s = SequenceOn()
        b = B()
        b.funcB1()
        b.funcB2()
