"use client"

import { useState } from "react"
import { Input } from "@/components/ui/input"
import { Button } from "@/components/ui/button"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Badge } from "@/components/ui/badge"
import { Loader2 } from "lucide-react"

interface SearchResult {
    id: string
    title: string
    source: "database" | "api"
}

export default function SearchPage() {
    const [query, setQuery] = useState("")
    const [results, setResults] = useState<SearchResult[]>([])
    const [isLoading, setIsLoading] = useState(false)

    const handleSearch = async () => {
        if (query.trim().length === 0)
            return

        setResults([])
        setIsLoading(true)
        try {
            const res = await fetch(`http://localhost:3000/movies/search?q=${query}`, {
                method: 'GET',
                headers: {
                    'Content-Type': 'application/json',
                },
                mode: 'cors',
            });

            const data = await res.json();
            console.log(data);
            setResults(data);
        } catch (err) {
            console.error('Fetch error:', err);

        } finally {
            setIsLoading(false)
            setQuery("")
        }
    }

    return (
        <main className="container mx-auto py-8 px-4">
            <h1 className="text-2xl font-bold mb-6">Movie Search</h1>

            <div className="flex gap-2 mb-6">
                <Input
                    type="text"
                    placeholder="Search..."
                    value={query}
                    onChange={(e) => setQuery(e.target.value)}
                    className="flex-1"
                    onKeyDown={(e) => e.key === "Enter" && handleSearch()}
                />
                <Button onClick={handleSearch} disabled={isLoading}>
                    {isLoading ? (
                        <>
                            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                            Searching...
                        </>
                    ) : (
                        "Search"
                    )}
                </Button>
            </div>

            {results.length > 0 ? (
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Title</TableHead>
                            <TableHead className="text-right">Source</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {results.map((result, index) => (
                            <TableRow key={result.id ?? `fallback-${index}`}>
                                <TableCell className="font-medium">{result.title}</TableCell>
                                <TableCell className="text-right">
                                    <Badge variant={result.source === "database" ? "secondary" : "default"}>
                                        {result.source === "database" ? "Database" : "API"}
                                    </Badge>
                                </TableCell>
                            </TableRow>
                        ))}
                    </TableBody>
                </Table>
            ) : isLoading ? (
                <div className="flex justify-center py-8">
                    <Loader2 className="h-8 w-8 animate-spin text-primary" />
                </div>
            ) : query.trim().length > 0 ? (
                <div className="text-center py-8 text-muted-foreground">No results found</div>
            ) : null}
        </main>
    )
}
