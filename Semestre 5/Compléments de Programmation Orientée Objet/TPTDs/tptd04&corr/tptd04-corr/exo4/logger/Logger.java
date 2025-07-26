package logger;

import java.util.ArrayList;
import java.util.List;

public class Logger {
    private final List<LogEntry> log;
    private final LogEntryAbstractFactory entryFactory;

    public Logger(LogEntryAbstractFactory llFactory) {
        log = new ArrayList<>();
        this.entryFactory = llFactory;
    }

    public void printShortLog() {
        for (LogEntry l: log) System.out.println(l.shortPrint());
    }

    public void printPrettyLog() {
        for (LogEntry l: log) {
            System.out.println(l.prettyPrint());
            System.out.println("-------------");
        }
    }

    public void log(int value) {
        log.add(entryFactory.newIntEntry(value));
    }
    public void log(boolean value) {
        log.add(entryFactory.newBoolEntry(value));
    }

}
