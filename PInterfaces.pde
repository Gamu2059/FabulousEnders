public interface Copyable<R> {
    public void CopyTo(R copy);
}

public interface IEvent {
    public void Event();
}

public interface ITimer {
    public void OnInit();
    public void OnTimeOut();
}

public interface IDuration {
    public void OnInit();
    public void OnUpdate();
    public void OnEnd();
    public boolean IsContinue();
}