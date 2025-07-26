package logger;

public interface LogEntryAbstractFactory {
    LogEntry newIntEntry(int value);
    LogEntry newBoolEntry(boolean value);
}
