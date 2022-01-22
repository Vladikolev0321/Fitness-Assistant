class DummyChat:
    def __init__(self, fitness_assistant):
        self.__fitness_assist = fitness_assistant

    def accept_message(self, message):
        if(message == "steps?"):
            return self.__fitness_assist.get_steps_done_today()