package client;

import logger.LogEntryAbstractFactory;
import logger.LogEntry;

public class LogEntryConcreteFactory implements LogEntryAbstractFactory {
    @Override
    public LogEntry newIntEntry(int value) {
        return new LogEntry() {
            @Override
            public String shortPrint() {
                return value + ", ";
            }

            @Override
            public String prettyPrint() {
                return "Entier : "  + value + ";";
            }
        };
    }

    @Override
    public LogEntry newBoolEntry(boolean value) {
        return new LogEntry() {
            @Override
            public String shortPrint() {
                return value + ", ";
            }

            @Override
            public String prettyPrint() {
                return "Booléen : "  + value + ";";
            }
        };
    }
}
